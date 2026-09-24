import fs from 'fs';

const content = `import { Router } from 'express';
import deliveryChargesController from './delivery-charges.controller.js';
import protect from '../../middlewares/auth.middleware.js';

const router = Router();

// Public / Customer read & calculate
router.get('/', deliveryChargesController.getAll);
router.get('/calculate', deliveryChargesController.calculate);
router.post('/calculate', deliveryChargesController.calculate);

// Protected admin mutations
router.post('/', protect, deliveryChargesController.create);
router.patch('/:id', protect, deliveryChargesController.update);
router.delete('/:id', protect, deliveryChargesController.delete);

export default router;
`;

fs.writeFileSync('d:/sudharsan/spare_api/src/modules/delivery-charges/delivery-charges.routes.js', content, 'utf8');
console.log('Fixed delivery-charges.routes.js');
