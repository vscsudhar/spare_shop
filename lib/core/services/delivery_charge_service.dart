import 'package:flutter/foundation.dart';
import 'package:spare_shop/app/app.locator.dart';
import 'package:spare_shop/core/services/api_client.dart';
import 'package:spare_shop/core/services/api_endpoints.dart';
import 'package:spare_shop/ui/common/delivery_charge_models.dart';

class DeliveryChargeService {
  final ApiClient _apiClient;
  List<DeliveryChargeModel> _cachedTiers = [];

  DeliveryChargeService({ApiClient? apiClient})
      : _apiClient = apiClient ?? locator<ApiClient>();

  List<DeliveryChargeModel> get cachedTiers =>
      _cachedTiers.isNotEmpty ? _cachedTiers : DeliveryChargeModel.defaultTiers();

  Future<List<DeliveryChargeModel>> getDeliveryCharges({String? locationId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (locationId != null && locationId.isNotEmpty && locationId != 'all') {
        queryParams['locationId'] = locationId;
      }

      final response = await _apiClient.get(
        ApiEndpoints.deliveryCharges,
        queryParameters: queryParams,
      );

      final List<dynamic>? list = response.data['data'];
      if (list != null && list.isNotEmpty) {
        _cachedTiers = list
            .map((item) => DeliveryChargeModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return _cachedTiers;
      }
    } catch (e) {
      debugPrint('Error fetching delivery charges from API: $e');
    }

    if (_cachedTiers.isEmpty) {
      _cachedTiers = DeliveryChargeModel.defaultTiers();
    }
    return _cachedTiers;
  }

  double calculateFee(double subTotal, [List<DeliveryChargeModel>? tiers]) {
    final activeTiers = (tiers != null && tiers.isNotEmpty)
        ? tiers
        : cachedTiers;

    if (subTotal <= 0) return 0.0;

    for (final tier in activeTiers) {
      if (!tier.isActive) continue;
      final from = tier.fromAmount;
      final to = tier.toAmount;

      if (to == null) {
        if (subTotal >= from) {
          return tier.deliveryCharge;
        }
      } else {
        if (subTotal >= from && subTotal <= to) {
          return tier.deliveryCharge;
        }
      }
    }

    // Default fallback
    return subTotal >= 1000 ? 0.0 : 100.0;
  }

  double? getFreeDeliveryThreshold([List<DeliveryChargeModel>? tiers]) {
    final activeTiers = (tiers != null && tiers.isNotEmpty)
        ? tiers
        : cachedTiers;

    for (final tier in activeTiers) {
      if (tier.isActive && tier.isFreeDelivery) {
        return tier.fromAmount;
      }
    }
    return 1000.0;
  }
}
