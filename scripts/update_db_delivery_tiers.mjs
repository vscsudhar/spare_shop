import mongoose from 'file:///d:/sudharsan/spare_api/node_modules/mongoose/index.js';

async function updateTiers() {
  await mongoose.connect('mongodb://127.0.0.1:27017/voltspare');
  const collection = mongoose.connection.collection('deliverycharges');
  
  await collection.deleteMany({});
  
  const tiers = [
    {
      fromAmount: 0,
      toAmount: 998,
      deliveryCharge: 59,
      locationId: null,
      locationName: 'All Locations (HQ)',
      description: 'Standard delivery charge ₹59 for orders under ₹999',
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    },
    {
      fromAmount: 999,
      toAmount: null,
      deliveryCharge: 0,
      locationId: null,
      locationName: 'All Locations (HQ)',
      description: 'FREE Delivery on orders ₹999 and above',
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    },
  ];
  
  await collection.insertMany(tiers);
  console.log('Successfully updated delivery charge tiers in MongoDB!');
  
  const saved = await collection.find({}).toArray();
  console.log('New Tiers in DB:', saved);
  
  await mongoose.disconnect();
}

updateTiers().catch(console.error);
