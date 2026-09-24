import mongoose from 'file:///d:/sudharsan/spare_api/node_modules/mongoose/index.js';

async function check() {
  await mongoose.connect('mongodb://127.0.0.1:27017/voltspare');
  const collections = await mongoose.connection.db.listCollections().toArray();
  console.log('Collections:', collections.map(c => c.name));
  
  const settings = await mongoose.connection.collection('settings').findOne({});
  console.log('Settings:', JSON.stringify(settings, null, 2));
  
  for (const coll of collections) {
    if (coll.name.toLowerCase().includes('delivery') || coll.name.toLowerCase().includes('charge') || coll.name.toLowerCase().includes('fee') || coll.name.toLowerCase().includes('rule') || coll.name.toLowerCase().includes('shipping')) {
      const docs = await mongoose.connection.collection(coll.name).find({}).toArray();
      console.log(`Collection ${coll.name} docs:`, docs);
    }
  }

  const locations = await mongoose.connection.collection('locations').find({}).toArray();
  console.log('Locations count:', locations.length);
  if (locations.length > 0) {
    console.log('Sample location:', locations[0]);
  }
  
  await mongoose.disconnect();
}

check().catch(console.error);
