// Test script to verify backend calculation and matching logic independently
function calculateDistanceKm(lat1, lon1, lat2, lon2) {
  const R = 6371; // Earth's radius in km
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLon = ((lon2 - lon1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

// Sample locations (Admin created hubs)
const hubs = [
  { _id: 'hub_madukkarai', name: 'Madukkarai', radiusKm: 20, location: { type: 'Point', coordinates: [76.9632, 10.9068] } },
  { _id: 'hub_peelamedu', name: 'Peelamedu', radiusKm: 20, location: { type: 'Point', coordinates: [77.0050, 11.0250] } },
  { _id: 'hub_eachanari', name: 'Eachanari', radiusKm: 20, location: { type: 'Point', coordinates: [76.9745, 10.9321] } },
];

function findNearestHubTest(latitude, longitude, activeLocations = hubs) {
  if (latitude === undefined || latitude === null || longitude === undefined || longitude === null) {
    return { locationId: null, locationName: null, distanceFromLocationKm: null, serviceAvailable: false, location: null };
  }

  const lat = Number(latitude);
  const lng = Number(longitude);
  if (isNaN(lat) || isNaN(lng)) {
    return { locationId: null, locationName: null, distanceFromLocationKm: null, serviceAvailable: false, location: null };
  }

  let nearest = null;
  let minDistance = Infinity;

  for (const loc of activeLocations) {
    let locLat, locLng;
    if (loc.location && Array.isArray(loc.location.coordinates) && loc.location.coordinates.length >= 2) {
      locLng = loc.location.coordinates[0];
      locLat = loc.location.coordinates[1];
    }

    if (locLat !== undefined && locLng !== undefined) {
      const dist = calculateDistanceKm(lat, lng, locLat, locLng);
      if (dist < minDistance) {
        minDistance = dist;
        nearest = loc;
      }
    }
  }

  if (!nearest) {
    return { locationId: null, locationName: null, distanceFromLocationKm: null, serviceAvailable: false, location: null };
  }

  const radiusKm = nearest.radiusKm ?? 20;
  const distanceRounded = Math.round(minDistance * 100) / 100;

  if (minDistance <= radiusKm) {
    return {
      locationId: nearest._id,
      locationName: nearest.name,
      distanceFromLocationKm: distanceRounded,
      serviceAvailable: true,
      location: {
        id: nearest._id.toString(),
        name: nearest.name,
        distanceKm: distanceRounded,
      },
    };
  } else {
    return {
      locationId: null,
      locationName: null,
      distanceFromLocationKm: distanceRounded,
      serviceAvailable: false,
      location: null,
    };
  }
}

// Tests
console.log('--- Test 1: Near Madukkarai (Lat: 10.9100, Lng: 76.9600) ---');
const res1 = findNearestHubTest(10.9100, 76.9600);
console.log(res1);
if (res1.locationName === 'Madukkarai' && res1.serviceAvailable === true) {
  console.log('PASS: Within radius');
} else {
  console.error('FAIL');
}

console.log('\n--- Test 2: Outside Service Radius (e.g., Lat: 13.0827, Lng: 80.2707 - Chennai, ~400km away) ---');
const res2 = findNearestHubTest(13.0827, 80.2707);
console.log(res2);
if (res2.locationId === null && res2.serviceAvailable === false && res2.distanceFromLocationKm > 20) {
  console.log('PASS: Correctly rejected hub assignment while calculating distance');
} else {
  console.error('FAIL');
}

console.log('\n--- Test 3: Backward compatibility with missing coordinates ---');
const res3 = findNearestHubTest(undefined, undefined);
console.log(res3);
if (res3.locationId === null && res3.serviceAvailable === false) {
  console.log('PASS: Handled gracefully without crash');
} else {
  console.error('FAIL');
}
