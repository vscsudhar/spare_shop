import 'package:spare_shop/app/app.locator.dart';
import 'api_client.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'voltspare_models_extensions.dart';

class VehicleService {
  final ApiClient _apiClient;

  VehicleService({ApiClient? apiClient})
      : _apiClient = apiClient ?? locator<ApiClient>();

  Future<List<VehicleModel>> getVehicles() async {
    final response = await _apiClient.get('/customers/vehicles');
    final List<dynamic> list = response.data['data'] ?? [];
    return list.map((item) => VehicleModelExtension.fromJson(item)).toList();
  }

  Future<VehicleModel> addVehicle(VehicleModel vehicle) async {
    final response = await _apiClient.post(
      '/customers/vehicles',
      data: vehicle.toJson(),
    );
    final data = response.data['data'] ?? {};
    return VehicleModelExtension.fromJson(data);
  }

  Future<VehicleModel> updateVehicle(String id, VehicleModel vehicle) async {
    final response = await _apiClient.put(
      '/customers/vehicles/$id',
      data: vehicle.toJson(),
    );
    final data = response.data['data'] ?? {};
    return VehicleModelExtension.fromJson(data);
  }

  Future<void> deleteVehicle(String id) async {
    await _apiClient.delete('/customers/vehicles/$id');
  }
}
