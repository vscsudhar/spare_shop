import fs from 'fs';

// 1. Update orders.model.js
const modelPath = 'd:/sudharsan/spare_api/src/modules/orders/orders.model.js';
let modelContent = fs.readFileSync(modelPath, 'utf8');

const targetSnapshotSchema = `const shippingAddressSnapshotSchema = new mongoose.Schema({
  recipientName: { type: String, required: true },
  phone: { type: String, required: true },
  addressLine1: { type: String, required: true },
  addressLine2: { type: String },
  city: { type: String, required: true },
  state: { type: String, required: true },
  postalCode: { type: String, required: true },
  country: { type: String, required: true, default: 'India' },
});`;

const replacementSnapshotSchema = `const shippingAddressSnapshotSchema = new mongoose.Schema({
  recipientName: { type: String, required: true },
  phone: { type: String, required: true },
  addressLine1: { type: String, required: true },
  addressLine2: { type: String },
  city: { type: String, required: true },
  state: { type: String, required: true },
  postalCode: { type: String, required: true },
  country: { type: String, required: true, default: 'India' },
  latitude: { type: Number, default: null },
  longitude: { type: Number, default: null },
  locationId: { type: mongoose.Schema.Types.ObjectId, ref: 'Location', default: null },
  locationName: { type: String, default: null },
  distanceFromLocationKm: { type: Number, default: null },
});`;

if (modelContent.includes(targetSnapshotSchema)) {
  modelContent = modelContent.replace(targetSnapshotSchema, replacementSnapshotSchema);
}

// Add locationId, locationName, distanceFromLocationKm to orderSchema if not present
if (!modelContent.includes('locationId: {')) {
  modelContent = modelContent.replace(
    `shippingAddress: {
      type: shippingAddressSnapshotSchema,
      required: true,
    },`,
    `shippingAddress: {
      type: shippingAddressSnapshotSchema,
      required: true,
    },
    locationId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Location',
      default: null,
    },
    locationName: {
      type: String,
      default: null,
      trim: true,
    },
    distanceFromLocationKm: {
      type: Number,
      default: null,
    },`
  );
}

// Add index
if (!modelContent.includes('orderSchema.index({ locationId: 1 });')) {
  modelContent = modelContent.replace(
    'orderSchema.index({ user: 1 });',
    `orderSchema.index({ user: 1 });\norderSchema.index({ locationId: 1 });`
  );
}

fs.writeFileSync(modelPath, modelContent, 'utf8');
console.log('Updated orders.model.js');

// 2. Update orders.service.js
const servicePath = 'd:/sudharsan/spare_api/src/modules/orders/orders.service.js';
let serviceContent = fs.readFileSync(servicePath, 'utf8');

const targetAddressSection = `      // 7. Save Address Snapshots
      const shippingAddress = {
        recipientName: address.recipientName,
        phone: address.phone,
        addressLine1: address.addressLine1,
        addressLine2: address.addressLine2,
        city: address.city,
        state: address.state,
        postalCode: address.postalCode,
        country: address.country,
      };

      // 8. Place the Order doc
      const order = await Order.create(
        [
          {
            orderNumber,
            user: userId,
            items: orderItems,
            shippingAddress,
            subTotal,
            taxAmount,
            discountAmount,
            deliveryFee,
            grandTotal,
            couponCode: cart.coupon ? cart.coupon.code : null,
            idempotencyKey: clientIdempotencyKey || undefined,
            statusHistory: [{ status: 'pending', notes: 'Order placed successfully' }],
          },
        ],
        { session }
      );`;

const replacementAddressSection = `      // 7. Save Address Snapshots with Coordinates and Location Hub Assignment
      const shippingAddress = {
        recipientName: address.recipientName,
        phone: address.phone,
        addressLine1: address.addressLine1,
        addressLine2: address.addressLine2,
        city: address.city,
        state: address.state,
        postalCode: address.postalCode,
        country: address.country,
        latitude: address.latitude ?? null,
        longitude: address.longitude ?? null,
        locationId: address.locationId ?? null,
        locationName: address.locationName ?? null,
        distanceFromLocationKm: address.distanceFromLocationKm ?? null,
      };

      // 8. Place the Order doc assigned to the nearest Hub
      const order = await Order.create(
        [
          {
            orderNumber,
            user: userId,
            items: orderItems,
            shippingAddress,
            locationId: address.locationId ?? null,
            locationName: address.locationName ?? null,
            distanceFromLocationKm: address.distanceFromLocationKm ?? null,
            subTotal,
            taxAmount,
            discountAmount,
            deliveryFee,
            grandTotal,
            couponCode: cart.coupon ? cart.coupon.code : null,
            idempotencyKey: clientIdempotencyKey || undefined,
            statusHistory: [{ status: 'pending', notes: 'Order placed successfully' }],
          },
        ],
        { session }
      );`;

if (serviceContent.includes(targetAddressSection)) {
  serviceContent = serviceContent.replace(targetAddressSection, replacementAddressSection);
  fs.writeFileSync(servicePath, serviceContent, 'utf8');
  console.log('Updated orders.service.js');
} else {
  console.log('Target address section not matched in orders.service.js');
}
