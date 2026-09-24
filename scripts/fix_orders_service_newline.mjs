import fs from 'fs';

const ordersServicePath = 'd:/sudharsan/spare_api/src/modules/orders/orders.service.js';
let content = fs.readFileSync(ordersServicePath, 'utf8');
content = content.replace(`import deliveryChargesService from '../delivery-charges/delivery-charges.service.js';\\n`, `import deliveryChargesService from '../delivery-charges/delivery-charges.service.js';\n`);
fs.writeFileSync(ordersServicePath, content, 'utf8');
console.log('Fixed newline in orders.service.js');
