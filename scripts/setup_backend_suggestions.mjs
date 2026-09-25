import fs from 'fs';
import path from 'path';

const baseDir = path.resolve('..', 'spare_api', 'src', 'modules', 'suggestions');
if (!fs.existsSync(baseDir)) {
  fs.mkdirSync(baseDir, { recursive: true });
}

// 1. Model
const modelCode = `import mongoose from 'mongoose';

const suggestionSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Users',
      default: null,
    },
    name: {
      type: String,
      required: [true, 'User name is required'],
      trim: true,
    },
    phone: {
      type: String,
      required: [true, 'Mobile number is required'],
      trim: true,
    },
    suggestion: {
      type: String,
      required: [true, 'Suggestion text is required'],
      trim: true,
    },
    status: {
      type: String,
      enum: ['pending', 'reviewed', 'resolved'],
      default: 'pending',
    },
    adminNotes: {
      type: String,
      default: '',
    },
  },
  {
    timestamps: true,
  }
);

suggestionSchema.index({ createdAt: -1 });
suggestionSchema.index({ status: 1 });

export const Suggestion =
  mongoose.models.Suggestion || mongoose.model('Suggestion', suggestionSchema);

export default Suggestion;
`;

fs.writeFileSync(path.join(baseDir, 'suggestions.model.js'), modelCode);

// 2. Service
const serviceCode = `import AppError from '../../errors/AppError.js';
import Suggestion from './suggestions.model.js';

export const suggestionsService = {
  createSuggestion: async (userId, data) => {
    const { name, phone, suggestion } = data;
    if (!name || !phone || !suggestion) {
      throw new AppError('Name, phone number and suggestion text are required', 400);
    }

    const doc = await Suggestion.create({
      user: userId || null,
      name: name.trim(),
      phone: phone.trim(),
      suggestion: suggestion.trim(),
      status: 'pending',
    });

    return doc;
  },

  getAllSuggestions: async (query = {}) => {
    const filter = {};
    if (query.status && query.status !== 'all') {
      filter.status = query.status;
    }
    if (query.search) {
      const regex = new RegExp(query.search, 'i');
      filter.$or = [{ name: regex }, { phone: regex }, { suggestion: regex }];
    }

    const suggestions = await Suggestion.find(filter)
      .populate('user', 'name email phone profileImage')
      .sort({ createdAt: -1 });

    return suggestions;
  },

  getSuggestionById: async (id) => {
    const doc = await Suggestion.findById(id).populate('user', 'name email phone profileImage');
    if (!doc) {
      throw new AppError('Suggestion not found', 404);
    }
    return doc;
  },

  updateStatus: async (id, status, adminNotes = '') => {
    const doc = await Suggestion.findById(id);
    if (!doc) {
      throw new AppError('Suggestion not found', 404);
    }
    if (status) doc.status = status;
    if (adminNotes !== undefined) doc.adminNotes = adminNotes;
    await doc.save();
    return doc;
  },

  deleteSuggestion: async (id) => {
    const doc = await Suggestion.findByIdAndDelete(id);
    if (!doc) {
      throw new AppError('Suggestion not found', 404);
    }
    return { id };
  },
};

export default suggestionsService;
`;

fs.writeFileSync(path.join(baseDir, 'suggestions.service.js'), serviceCode);

// 3. Controller
const controllerCode = `import catchAsync from '../../utils/catchAsync.js';
import suggestionsService from './suggestions.service.js';

export const suggestionsController = {
  createSuggestion: catchAsync(async (req, res) => {
    const userId = req.user ? req.user._id : null;
    const data = await suggestionsService.createSuggestion(userId, req.body);
    res.status(201).json({
      success: true,
      message: 'Suggestion submitted successfully. Thank you for your feedback!',
      data,
    });
  }),

  getAllSuggestions: catchAsync(async (req, res) => {
    const suggestions = await suggestionsService.getAllSuggestions(req.query);
    res.status(200).json({
      success: true,
      message: 'Suggestions retrieved successfully',
      data: suggestions,
    });
  }),

  getSuggestionById: catchAsync(async (req, res) => {
    const suggestion = await suggestionsService.getSuggestionById(req.params.id);
    res.status(200).json({
      success: true,
      message: 'Suggestion retrieved successfully',
      data: suggestion,
    });
  }),

  updateStatus: catchAsync(async (req, res) => {
    const { status, adminNotes } = req.body;
    const updated = await suggestionsService.updateStatus(req.params.id, status, adminNotes);
    res.status(200).json({
      success: true,
      message: 'Suggestion status updated successfully',
      data: updated,
    });
  }),

  deleteSuggestion: catchAsync(async (req, res) => {
    await suggestionsService.deleteSuggestion(req.params.id);
    res.status(200).json({
      success: true,
      message: 'Suggestion deleted successfully',
      data: { id: req.params.id },
    });
  }),
};

export default suggestionsController;
`;

fs.writeFileSync(path.join(baseDir, 'suggestions.controller.js'), controllerCode);

// 4. Routes
const routesCode = `import { Router } from 'express';
import suggestionsController from './suggestions.controller.js';
import protect from '../../middlewares/auth.middleware.js';
import restrictTo from '../../middlewares/permission.middleware.js';

const router = Router();
const adminRouter = Router();

// Optional authentication middleware for customer submission
const optionalAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      return protect(req, res, next);
    }
  } catch (_) {}
  next();
};

// Customer routes
router.post('/', optionalAuth, suggestionsController.createSuggestion);
router.post('/submit', optionalAuth, suggestionsController.createSuggestion);

// Admin routes
adminRouter.use(protect);
adminRouter.use(restrictTo('admin', 'staff', 'superadmin', 'owner'));

adminRouter.get('/', suggestionsController.getAllSuggestions);
adminRouter.get('/:id', suggestionsController.getSuggestionById);
adminRouter.patch('/:id/status', suggestionsController.updateStatus);
adminRouter.delete('/:id', suggestionsController.deleteSuggestion);

export { adminRouter as adminSuggestionsRouter };
export default router;
`;

fs.writeFileSync(path.join(baseDir, 'suggestions.routes.js'), routesCode);

// 5. Update index.js
const routesIndexFile = path.resolve('..', 'spare_api', 'src', 'routes', 'index.js');
let routesIndexContent = fs.readFileSync(routesIndexFile, 'utf8');

if (!routesIndexContent.includes('suggestions.routes.js')) {
  // Add import
  routesIndexContent = routesIndexContent.replace(
    "import deliveryChargesRoutes from '../modules/delivery-charges/delivery-charges.routes.js';",
    "import deliveryChargesRoutes from '../modules/delivery-charges/delivery-charges.routes.js';\nimport suggestionsRoutes, { adminSuggestionsRouter } from '../modules/suggestions/suggestions.routes.js';"
  );
  // Add router.use
  routesIndexContent = routesIndexContent.replace(
    "router.use('/delivery-charges', deliveryChargesRoutes);",
    "router.use('/delivery-charges', deliveryChargesRoutes);\nrouter.use('/suggestions', suggestionsRoutes);\nrouter.use('/admin/suggestions', adminSuggestionsRouter);"
  );
  fs.writeFileSync(routesIndexFile, routesIndexContent);
  console.log('Updated spare_api/src/routes/index.js');
}

console.log('Successfully set up suggestions backend module!');
