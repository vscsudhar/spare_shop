import 'package:flutter/foundation.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'api_client.dart';
import 'api_endpoints.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';
import 'voltspare_models_extensions.dart';

class WishlistService {
  final ApiClient _apiClient;

  static final RegExp _objectIdRegExp = RegExp(r'^[0-9a-fA-F]{24}$');
  static bool isValidObjectId(String id) => _objectIdRegExp.hasMatch(id);

  final Set<String> _wishlistedProductIds = {};
  final Set<String> _loadingProductIds = {};

  final ValueNotifier<Set<String>> wishlistedProductIdsNotifier =
      ValueNotifier<Set<String>>({});

  WishlistService({ApiClient? apiClient})
      : _apiClient = apiClient ?? locator<ApiClient>();

  Set<String> get wishlistedProductIds =>
      Set.unmodifiable(_wishlistedProductIds);

  bool isProductWishlisted(String productId) =>
      _wishlistedProductIds.contains(productId);

  bool isProductLoading(String productId) =>
      _loadingProductIds.contains(productId);

  void _notifyChange() {
    wishlistedProductIdsNotifier.value = Set.from(_wishlistedProductIds);
  }

  Future<List<ProductModel>> getWishlist() async {
    List<ProductModel> products = [];
    try {
      final response = await _apiClient.get(ApiEndpoints.wishlist);
      dynamic data = response.data['data'];
      List<dynamic> list = [];
      if (data is List) {
        list = data;
      } else if (data is Map && data['products'] is List) {
        list = data['products'];
      }

      products = list
          .where((item) => item != null)
          .map((item) =>
              ProductModelExtension.fromJson(item as Map<String, dynamic>))
          .toList();

      final serverIds = products.map((p) => p.id).toSet();
      // Keep any local mock IDs that were wishlisted
      final localMockIds =
          _wishlistedProductIds.where((id) => !isValidObjectId(id)).toSet();

      _wishlistedProductIds.clear();
      _wishlistedProductIds.addAll(serverIds);
      _wishlistedProductIds.addAll(localMockIds);
      _notifyChange();
    } catch (_) {
      // Offline / fallback: keep current IDs
    }

    return products;
  }

  Future<bool> toggleWishlist(String productId) async {
    if (productId.isEmpty) return false;
    if (_loadingProductIds.contains(productId)) {
      return _wishlistedProductIds.contains(productId);
    }

    // If not a MongoDB ObjectId (e.g. mock product id like 'prod_ola_chg'), handle locally
    if (!isValidObjectId(productId)) {
      if (_wishlistedProductIds.contains(productId)) {
        _wishlistedProductIds.remove(productId);
      } else {
        _wishlistedProductIds.add(productId);
      }
      _notifyChange();
      return _wishlistedProductIds.contains(productId);
    }

    _loadingProductIds.add(productId);
    final previousState = _wishlistedProductIds.contains(productId);

    // Optimistically update local state
    if (previousState) {
      _wishlistedProductIds.remove(productId);
    } else {
      _wishlistedProductIds.add(productId);
    }
    _notifyChange();

    try {
      final response = await _apiClient.patch(
        '${ApiEndpoints.wishlist}/$productId/toggle',
      );

      final data = response.data['data'];
      final bool serverWishlistState =
          data is Map && data['isWishlist'] == true;

      if (serverWishlistState) {
        _wishlistedProductIds.add(productId);
      } else {
        _wishlistedProductIds.remove(productId);
      }
      _notifyChange();
      return serverWishlistState;
    } catch (e) {
      // Rollback on failure
      if (previousState) {
        _wishlistedProductIds.add(productId);
      } else {
        _wishlistedProductIds.remove(productId);
      }
      _notifyChange();
      rethrow;
    } finally {
      _loadingProductIds.remove(productId);
    }
  }

  Future<bool> addToWishlist(String productId) async {
    if (productId.isEmpty) return false;
    if (_loadingProductIds.contains(productId)) {
      return _wishlistedProductIds.contains(productId);
    }

    if (!isValidObjectId(productId)) {
      _wishlistedProductIds.add(productId);
      _notifyChange();
      return true;
    }

    _loadingProductIds.add(productId);
    try {
      final response = await _apiClient.post(
        '${ApiEndpoints.wishlist}/$productId',
      );
      final data = response.data['data'];
      final bool serverWishlistState =
          data is Map && data['isWishlist'] == true;
      if (serverWishlistState) {
        _wishlistedProductIds.add(productId);
        _notifyChange();
      }
      return serverWishlistState;
    } catch (_) {
      rethrow;
    } finally {
      _loadingProductIds.remove(productId);
    }
  }

  Future<bool> removeFromWishlist(String productId) async {
    if (productId.isEmpty) return false;
    if (_loadingProductIds.contains(productId)) {
      return _wishlistedProductIds.contains(productId);
    }

    if (!isValidObjectId(productId)) {
      _wishlistedProductIds.remove(productId);
      _notifyChange();
      return false;
    }

    _loadingProductIds.add(productId);
    try {
      final response = await _apiClient.delete(
        '${ApiEndpoints.wishlist}/$productId',
      );
      final data = response.data['data'];
      final bool isWishlist = data is Map && data['isWishlist'] == true;
      if (!isWishlist) {
        _wishlistedProductIds.remove(productId);
        _notifyChange();
      }
      return isWishlist;
    } catch (_) {
      rethrow;
    } finally {
      _loadingProductIds.remove(productId);
    }
  }
}
