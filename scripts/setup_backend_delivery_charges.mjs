import fs from 'fs';
import path from 'path';

const apiBase = 'd:/sudharsan/spare_api';
const dcDir = path.join(apiBase, 'src/modules/delivery-charges');
if (!fs.existsSync(dcDir)) {
  fs.mkdirSync(dcDir, { recursive: true });
}

// 1. delivery-charges.model.js
const modelContent = `import mongoose from 'mongoose';

const deliveryChargeSchema = new mongoose.Schema(
  {
    fromAmount: {
      type: Number,
      required: [true, 'From amount is required'],
      default: 0,
      min: 0,
    },
    toAmount: {
      type: Number,
      default: null,
    },
    deliveryCharge: {
      type: Number,
      required: [true, 'Delivery charge is required'],
      default: 0,
      min: 0,
    },
    locationId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Location',
      default: null,
    },
    locationName: {
      type: String,
      default: 'All Locations (HQ)',
      trim: true,
    },
    description: {
      type: String,
      trim: true,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

deliveryChargeSchema.index({ isActive: 1, locationId: 1, fromAmount: 1 });

export const DeliveryCharge =
  mongoose.models.DeliveryCharge ||
  mongoose.model('DeliveryCharge', deliveryChargeSchema);

export default DeliveryCharge;
`;
fs.writeFileSync(path.join(dcDir, 'delivery-charges.model.js'), modelContent, 'utf8');

// 2. delivery-charges.service.js
const serviceContent = `import AppError from '../../errors/AppError.js';
import DeliveryCharge from './delivery-charges.model.js';

export const deliveryChargesService = {
  /**
   * Retrieve all delivery charge tiers with optional location filter
   * Auto-seeds default tiers if collection is empty
   */
  getAll: async (queryParams = {}) => {
    const count = await DeliveryCharge.countDocuments();
    if (count === 0) {
      await DeliveryCharge.create([
        {
          fromAmount: 0,
          toAmount: 399,
          deliveryCharge: 60,
          locationName: 'All Locations (HQ)',
          description: 'Standard delivery for small orders under ₹399',
          isActive: true,
        },
        {
          fromAmount: 400,
          toAmount: 999,
          deliveryCharge: 100,
          locationName: 'All Locations (HQ)',
          description: 'Standard delivery for medium orders (₹400 - ₹999)',
          isActive: true,
        },
        {
          fromAmount: 1000,
          toAmount: null,
          deliveryCharge: 0,
          locationName: 'All Locations (HQ)',
          description: 'Free delivery on orders ₹1000 and above',
          isActive: true,
        },
      ]);
    }

    const filter = {};
    if (queryParams.isActive !== undefined) {
      filter.isActive = queryParams.isActive === 'true' || queryParams.isActive === true;
    }
    if (queryParams.locationId && queryParams.locationId !== 'all') {
      filter.$or = [
        { locationId: queryParams.locationId },
        { locationId: null },
      ];
    }

    return DeliveryCharge.find(filter).sort({ fromAmount: 1 });
  },

  /**
   * Calculate dynamic delivery fee based on order subTotal and optional locationId
   */
  calculateFee: async (subTotal = 0, locationId = null) => {
    const tiers = await deliveryChargesService.getAll({ isActive: true, locationId });
    if (!tiers || tiers.length === 0) {
      return subTotal >= 1000 ? 0 : 100;
    }

    // Match tier where fromAmount <= subTotal and (toAmount is null or subTotal <= toAmount)
    const matchedTier = tiers.find((t) => {
      const from = t.fromAmount ?? 0;
      const to = t.toAmount;
      if (to === null || to === undefined) {
        return subTotal >= from;
      }
      return subTotal >= from && subTotal <= to;
    });

    if (matchedTier) {
      return matchedTier.deliveryCharge;
    }

    // Default fallback
    return subTotal >= 1000 ? 0 : 100;
  },

  /**
   * Create new delivery charge tier
   */
  create: async (data) => {
    return DeliveryCharge.create(data);
  },

  /**
   * Update delivery charge tier
   */
  update: async (id, data) => {
    const tier = await DeliveryCharge.findByIdAndUpdate(id, data, { new: true, runValidators: true });
    if (!tier) {
      throw new AppError('Delivery charge tier not found', 404);
    }
    return tier;
  },

  /**
   * Delete delivery charge tier
   */
  delete: async (id) => {
    const tier = await DeliveryCharge.findByIdAndDelete(id);
    if (!tier) {
      throw new AppError('Delivery charge tier not found', 404);
    }
    return tier;
  },
};

export default deliveryChargesService;
`;
fs.writeFileSync(path.join(dcDir, 'delivery-charges.service.js'), serviceContent, 'utf8');

// 3. delivery-charges.controller.js
const controllerContent = `import deliveryChargesService from './delivery-charges.service.js';
import { sendResponse } from '../../utils/response.js';

export const deliveryChargesController = {
  getAll: async (req, res, next) => {
    try {
      const tiers = await deliveryChargesService.getAll(req.query);
      return sendResponse(res, 200, 'Delivery charges retrieved successfully', tiers);
    } catch (err) {
      next(err);
    }
  },

  calculate: async (req, res, next) => {
    try {
      const subTotal = Number(req.query.subTotal || req.body.subTotal || 0);
      const locationId = req.query.locationId || req.body.locationId || null;
      const deliveryFee = await deliveryChargesService.calculateFee(subTotal, locationId);
      return sendResponse(res, 200, 'Delivery fee calculated successfully', {
        subTotal,
        deliveryFee,
        isFreeDelivery: deliveryFee === 0,
      });
    } catch (err) {
      next(err);
    }
  },

  create: async (req, res, next) => {
    try {
      const tier = await deliveryChargesService.create(req.body);
      return sendResponse(res, 201, 'Delivery charge tier created successfully', tier);
    } catch (err) {
      next(err);
    }
  },

  update: async (req, res, next) => {
    try {
      const tier = await deliveryChargesService.update(req.params.id, req.body);
      return sendResponse(res, 200, 'Delivery charge tier updated successfully', tier);
    } catch (err) {
      next(err);
    }
  },

  delete: async (req, res, next) => {
    try {
      await deliveryChargesService.delete(req.params.id);
      return sendResponse(res, 200, 'Delivery charge tier deleted successfully', null);
    } catch (err) {
      next(err);
    }
  },
};

export default deliveryChargesController;
`;
fs.writeFileSync(path.join(dcDir, 'delivery-charges.controller.js'), controllerContent, 'utf8');

// 4. delivery-charges.routes.js
const routesContent = `import { Router } from 'express';
import deliveryChargesController from './delivery-charges.controller.js';
import { authenticate } from '../../middlewares/auth.js';

const router = Router();

// Public / Customer read & calculate
router.get('/', deliveryChargesController.getAll);
router.get('/calculate', deliveryChargesController.calculate);
router.post('/calculate', deliveryChargesController.calculate);

// Protected admin mutations
router.post('/', authenticate, deliveryChargesController.create);
router.patch('/:id', authenticate, deliveryChargesController.update);
router.delete('/:id', authenticate, deliveryChargesController.delete);

export default router;
`;
fs.writeFileSync(path.join(dcDir, 'delivery-charges.routes.js'), routesContent, 'utf8');

// 5. Update src/routes/index.js
const routesIndex = path.join(apiBase, 'src/routes/index.js');
let indexContent = fs.readFileSync(routesIndex, 'utf8');

if (!indexContent.includes('deliveryChargesRoutes')) {
  indexContent = indexContent.replace(
    `import locationsRoutes from '../modules/locations/locations.routes.js';`,
    `import locationsRoutes from '../modules/locations/locations.routes.js';\\nimport deliveryChargesRoutes from '../modules/delivery-charges/delivery-charges.routes.js';`
  );
  indexContent = indexContent.replace(
    `router.use('/locations', locationsRoutes);`,
    `router.use('/locations', locationsRoutes);\\nrouter.use('/delivery-charges', deliveryChargesRoutes);`
  );
  fs.writeFileSync(routesIndex, indexContent, 'utf8');
  console.log('Updated routes/index.js with /delivery-charges');
}

// 6. Update orders.service.js to calculate deliveryFee from deliveryChargesService
const ordersServicePath = path.join(apiBase, 'src/modules/orders/orders.service.js');
let ordersServiceContent = fs.readFileSync(ordersServicePath, 'utf8');

if (!ordersServiceContent.includes('deliveryChargesService')) {
  ordersServiceContent = `import deliveryChargesService from '../delivery-charges/delivery-charges.service.js';\\n` + ordersServiceContent;
}

ordersServiceContent = ordersServiceContent.replace(
  /const deliveryFee = subTotal >= 1000 \? 0 : 100;/g,
  `const deliveryFee = await deliveryChargesService.calculateFee(subTotal, address?.locationId || null);`
);

fs.writeFileSync(ordersServicePath, ordersServiceContent, 'utf8');
console.log('Updated orders.service.js with dynamic delivery fee calculation');
