import mongoose from 'file:///d:/sudharsan/spare_api/node_modules/mongoose/index.js';

async function sanitize() {
  await mongoose.connect('mongodb://127.0.0.1:27017/voltspare');
  const collection = mongoose.connection.collection('addresses');
  const addresses = await collection.find({}).toArray();
  console.log(`Found ${addresses.length} addresses.`);
  
  for (const addr of addresses) {
    let changed = false;
    let state = addr.state || '';
    let postalCode = addr.postalCode || '';
    
    if (state.includes('(Lat:')) {
      state = state.split('(Lat:')[0].trim();
      changed = true;
    }
    if (postalCode.includes('Lng:') || postalCode.includes('Lat:')) {
      postalCode = '641001';
      changed = true;
    }
    
    if (changed) {
      await collection.updateOne(
        { _id: addr._id },
        { $set: { state, postalCode } }
      );
      console.log(`Sanitized address ${addr._id} -> state: "${state}", postalCode: "${postalCode}"`);
    }
  }
  
  console.log('Cleanup completed successfully.');
  await mongoose.disconnect();
}

sanitize().catch(console.error);
