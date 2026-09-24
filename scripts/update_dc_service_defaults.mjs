import fs from 'fs';

const servicePath = 'd:/sudharsan/spare_api/src/modules/delivery-charges/delivery-charges.service.js';
let content = fs.readFileSync(servicePath, 'utf8');

content = content.replace(
  `        {
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
        },`,
  `        {
          fromAmount: 0,
          toAmount: 998,
          deliveryCharge: 59,
          locationName: 'All Locations (HQ)',
          description: 'Standard delivery charge ₹59 for orders under ₹999',
          isActive: true,
        },
        {
          fromAmount: 999,
          toAmount: null,
          deliveryCharge: 0,
          locationName: 'All Locations (HQ)',
          description: 'FREE Delivery on orders ₹999 and above',
          isActive: true,
        },`
);

content = content.replace(
  `return subTotal >= 1000 ? 0 : 100;`,
  `return subTotal >= 999 ? 0 : 59;`
);

fs.writeFileSync(servicePath, content, 'utf8');
console.log('Updated delivery-charges.service.js defaults');
