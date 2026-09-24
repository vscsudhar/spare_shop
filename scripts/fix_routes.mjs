import fs from 'fs';
const file = 'd:/sudharsan/spare_api/src/routes/index.js';
let content = fs.readFileSync(file, 'utf8');
content = content.replace(`router.use('/locations', locationsRoutes);\\nrouter.use('/delivery-charges', deliveryChargesRoutes);`, `router.use('/locations', locationsRoutes);\nrouter.use('/delivery-charges', deliveryChargesRoutes);`);
content = content.replace(`import locationsRoutes from '../modules/locations/locations.routes.js';\\nimport deliveryChargesRoutes from '../modules/delivery-charges/delivery-charges.routes.js';`, `import locationsRoutes from '../modules/locations/locations.routes.js';\nimport deliveryChargesRoutes from '../modules/delivery-charges/delivery-charges.routes.js';`);
fs.writeFileSync(file, content, 'utf8');
console.log('Fixed newlines in routes/index.js');
