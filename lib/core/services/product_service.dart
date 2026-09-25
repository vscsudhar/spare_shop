import 'package:flutter/material.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'api_client.dart';
import 'api_endpoints.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'package:spare_shop/ui/common/voltspare_mock_data.dart';
import 'voltspare_models_extensions.dart';

class ProductService {
  final ApiClient _apiClient;

  ProductService({ApiClient? apiClient})
      : _apiClient = apiClient ?? locator<ApiClient>();

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.categories);
      final List<dynamic> list = response.data['data'] ?? [];
      if (list.isEmpty) return mockCategories;
      return list.map((item) => CategoryModelExtension.fromJson(item)).toList();
    } catch (_) {
      return mockCategories;
    }
  }

  Future<List<ProductModel>> getProducts({
    String? type,
    String? categoryId,
    String? search,
    bool? featured,
  }) async {
    try {
      final Map<String, dynamic> query = {};
      if (type != null) query['type'] = type;
      if (categoryId != null && categoryId.isNotEmpty) {
        query['category'] = categoryId;
      }
      if (search != null && search.isNotEmpty) query['search'] = search;
      if (featured != null) query['featured'] = featured.toString();

      final response =
          await _apiClient.get(ApiEndpoints.products, queryParameters: query);
      final List<dynamic> list = response.data['data'] ?? [];

      if (list.isEmpty) {
        return _getMockProductsFiltered(
          categoryId: categoryId,
          featured: featured,
          search: search,
        );
      }

      return list.map((item) => ProductModelExtension.fromJson(item)).toList();
    } catch (_) {
      return _getMockProductsFiltered(
        categoryId: categoryId,
        featured: featured,
        search: search,
      );
    }
  }

  List<ProductModel> _getMockProductsFiltered({
    String? categoryId,
    bool? featured,
    String? search,
  }) {
    List<ProductModel> result = mockProducts;
    if (categoryId != null && categoryId.isNotEmpty) {
      result = result.where((p) => p.categoryId == categoryId).toList();
    }
    if (featured == true) {
      result = result.where((p) => p.isFeatured).toList();
    }
    if (search != null && search.isNotEmpty) {
      final queryStr = search.toLowerCase();
      result = result.where((p) {
        final catName = mockCategories
            .firstWhere((c) => c.id == p.categoryId,
                orElse: () => const CategoryModel(
                    id: '', name: '', icon: Icons.category))
            .name
            .toLowerCase();

        return p.name.toLowerCase().contains(queryStr) ||
            p.description.toLowerCase().contains(queryStr) ||
            catName.contains(queryStr) ||
            (p.fitmentBadge?.toLowerCase().contains(queryStr) ?? false);
      }).toList();
    }
    return result;
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await _apiClient.get('${ApiEndpoints.products}/$id');
      final data = response.data['data'] ?? {};
      return ProductModelExtension.fromJson(data);
    } catch (_) {
      return mockProducts.firstWhere((p) => p.id == id,
          orElse: () => mockProducts.first);
    }
  }

  Future<List<VehicleBrandModel>> getVehicleBrands() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.vehicleBrands);
      final List<dynamic> list = response.data['data'] ?? [];
      if (list.isEmpty) return [...mockEvBrands, ...mockPetrolBrands];
      return list
          .map((item) => VehicleBrandModelExtension.fromJson(item))
          .toList();
    } catch (_) {
      return [...mockEvBrands, ...mockPetrolBrands];
    }
  }

  Future<List<VehicleModel>> getVehicleModels() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.vehicleModels);
      final List<dynamic> list = response.data['data'] ?? [];
      if (list.isEmpty) return mockVehicles;
      return list.map((item) => VehicleModelExtension.fromJson(item)).toList();
    } catch (_) {
      return mockVehicles;
    }
  }

  Future<ProductModel> createProduct(Map<String, dynamic> payload) async {
    final response =
        await _apiClient.post(ApiEndpoints.products, data: payload);
    final data = response.data['data'] ?? {};
    return ProductModelExtension.fromJson(data);
  }

  Future<ProductModel> updateProduct(
      String id, Map<String, dynamic> payload) async {
    final response =
        await _apiClient.patch('${ApiEndpoints.products}/$id', data: payload);
    final data = response.data['data'] ?? {};
    return ProductModelExtension.fromJson(data);
  }
}
