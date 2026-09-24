import 'package:flutter_test/flutter_test.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/services/address_service.dart';
import 'package:spare_shop/core/services/voltspare_models_extensions.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/views/add_address/add_address_viewmodel.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('AddAddressViewModel Tests -', () {
    setUp(() {
      registerServices();
      if (!locator.isRegistered<AddressService>()) {
        locator.registerSingleton<AddressService>(AddressService());
      }
    });
    tearDown(() => locator.reset());

    test('Initializes with default Coimbatore coordinates when adding new address', () {
      final model = AddAddressViewModel();
      expect(model.latitude, 11.0123);
      expect(model.longitude, 76.9567);
      expect(model.isMapMoved, false);
      expect(model.stateController.text, 'Tamil Nadu');
      expect(model.districtController.text, 'Coimbatore');
    });

    test('Initializes with existing coordinates and fields when editing address', () {
      const existingAddress = AddressModel(
        id: 'addr_123',
        name: 'Office',
        phone: '+91 9876543210',
        addressLine: '123 Tech Park, Peelamedu, Coimbatore, Tamil Nadu',
        latitude: 10.9068,
        longitude: 76.9632,
        locationId: 'hub_madukkarai',
        locationName: 'Madukkarai',
        distanceFromLocationKm: 4.72,
      );

      final model = AddAddressViewModel(addressToEdit: existingAddress);
      expect(model.latitude, 10.9068);
      expect(model.longitude, 76.9632);
      expect(model.isMapMoved, true);
      expect(model.labelController.text, 'Office');
      expect(model.phoneController.text, '+91 9876543210');
      expect(model.doorNoController.text, '123 Tech Park');
      expect(model.talukController.text, 'Peelamedu');
      expect(model.districtController.text, 'Coimbatore');
      expect(model.stateController.text, 'Tamil Nadu');
      expect(model.locationName, 'Madukkarai');
      expect(model.distanceFromLocationKm, 4.72);
    });

    test('updateLocation updates coordinates and sets isMapMoved to true', () {
      final model = AddAddressViewModel();
      model.updateLocation(11.0250, 77.0050);
      expect(model.latitude, 11.0250);
      expect(model.longitude, 77.0050);
      expect(model.isMapMoved, true);
    });

    test('onAreaSelected updates taluk, district, state form fields', () {
      final model = AddAddressViewModel();
      model.onAreaSelected('Madukkarai', 'Coimbatore', 'Tamil Nadu');
      expect(model.talukController.text, 'Madukkarai');
      expect(model.districtController.text, 'Coimbatore');
      expect(model.stateController.text, 'Tamil Nadu');
    });

    test('AddressModel serialization includes coordinates and location hub fields', () {
      const address = AddressModel(
        id: 'addr_999',
        name: 'Home',
        phone: '+91 9999999999',
        addressLine: 'Door 10, Eachanari, Coimbatore, Tamil Nadu, 641021',
        latitude: 10.9321,
        longitude: 76.9745,
        locationId: 'loc_eachanari',
        locationName: 'Eachanari Hub',
        distanceFromLocationKm: 2.35,
      );

      final json = address.toJson();
      expect(json['name'], 'Home');
      expect(json['recipientName'], 'Home');
      expect(json['phone'], '+91 9999999999');
      expect(json['latitude'], 10.9321);
      expect(json['longitude'], 76.9745);
      expect(json['locationId'], 'loc_eachanari');
      expect(json['locationName'], 'Eachanari Hub');
      expect(json['distanceFromLocationKm'], 2.35);

      final deserialized = AddressModelExtension.fromJson({
        '_id': 'addr_999',
        'name': 'Home',
        'phone': '+91 9999999999',
        'addressLine1': 'Door 10',
        'addressLine2': 'Eachanari',
        'city': 'Coimbatore',
        'state': 'Tamil Nadu',
        'postalCode': '641021',
        'latitude': 10.9321,
        'longitude': 76.9745,
        'locationId': 'loc_eachanari',
        'locationName': 'Eachanari Hub',
        'distanceFromLocationKm': 2.35,
      });

      expect(deserialized.id, 'addr_999');
      expect(deserialized.name, 'Home');
      expect(deserialized.latitude, 10.9321);
      expect(deserialized.longitude, 76.9745);
      expect(deserialized.locationId, 'loc_eachanari');
      expect(deserialized.locationName, 'Eachanari Hub');
      expect(deserialized.distanceFromLocationKm, 2.35);
    });
  });
}
