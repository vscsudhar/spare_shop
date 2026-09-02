import 'voltspare_models.dart';

/// Enum representing the delivery window
enum DeliveryType {
  sameDay,
  nextDay,
  twoDays,
  outOfStock,
}

/// Dynamic delivery estimate object
class DeliveryEstimate {
  final DeliveryType type;
  final String title; // "Same Day Delivery", "Next Day Delivery", "Delivery in 2 Days", "Out of Stock"
  final String availabilityStatus; // "In Stock", "Available on Order", "Out of Stock"
  final String? cutoffNote; // "Order before 3:00 PM", "Same-day cutoff was 3:00 PM", null
  final bool isAvailable;
  final DateTime? estimatedDeliveryDate;

  const DeliveryEstimate({
    required this.type,
    required this.title,
    required this.availabilityStatus,
    this.cutoffNote,
    required this.isAvailable,
    this.estimatedDeliveryDate,
  });
}

/// Delivery summary across a whole cart
class CartDeliverySummary {
  final String summaryLabel;
  final String? secondaryNote;
  final bool isMixed;
  final DeliveryType slowestDeliveryType;

  const CartDeliverySummary({
    required this.summaryLabel,
    this.secondaryNote,
    this.isMixed = false,
    required this.slowestDeliveryType,
  });
}

/// Central Delivery Estimator
/// Pure in-memory calculation with zero network calls, zero DB queries, and zero side-effects.
class DeliveryEstimator {
  /// Converts any given DateTime (or now) to Asia/Kolkata business time (UTC + 5:30).
  /// If [isAlreadyBusinessTime] is true, the given time is assumed to already be in IST.
  static DateTime getBusinessTime([
    DateTime? time,
    bool isAlreadyBusinessTime = false,
  ]) {
    if (time != null && isAlreadyBusinessTime) {
      return time;
    }
    final dt = time ?? DateTime.now();
    return dt.toUtc().add(const Duration(hours: 5, minutes: 30));
  }

  /// 15:00:00 cutoff rule in Asia/Kolkata:
  /// Before or equal to 3:00 PM (15:00:00) -> true
  /// 3:01 PM onwards -> false
  static bool isWithinCutoff(DateTime businessTime) {
    if (businessTime.hour < 15) return true;
    if (businessTime.hour == 15 &&
        businessTime.minute == 0 &&
        businessTime.second == 0 &&
        businessTime.millisecond == 0) {
      return true;
    }
    return false;
  }

  /// Calculates the delivery estimate for a single product.
  /// [businessTime]: Optional override for testing or fixed calculations.
  /// [isAlreadyBusinessTime]: If true, does not re-apply the UTC+5:30 offset.
  static DeliveryEstimate getEstimate(
    ProductModel product, {
    DateTime? businessTime,
    bool isAlreadyBusinessTime = false,
  }) {
    // 1. Non-stock / On-demand product
    if (!product.stockManaged) {
      final nowBt = getBusinessTime(businessTime, isAlreadyBusinessTime);
      final estimatedDate = DateTime(
        nowBt.year,
        nowBt.month,
        nowBt.day,
      ).add(const Duration(days: 2));

      return DeliveryEstimate(
        type: DeliveryType.twoDays,
        title: 'Delivery in 2 Days',
        availabilityStatus: 'Available on Order',
        cutoffNote: null,
        isAvailable: true,
        estimatedDeliveryDate: estimatedDate,
      );
    }

    // 2. Stock-managed but out of stock
    if (product.stockCount == null || product.stockCount! <= 0) {
      return const DeliveryEstimate(
        type: DeliveryType.outOfStock,
        title: 'Out of Stock',
        availabilityStatus: 'Out of Stock',
        cutoffNote: null,
        isAvailable: false,
        estimatedDeliveryDate: null,
      );
    }

    // 3. Stock-managed with stock > 0
    final bt = getBusinessTime(businessTime, isAlreadyBusinessTime);
    final isSameDay = isWithinCutoff(bt);

    if (isSameDay) {
      return DeliveryEstimate(
        type: DeliveryType.sameDay,
        title: 'Same Day Delivery',
        availabilityStatus: 'In Stock',
        cutoffNote: 'Order before 3:00 PM',
        isAvailable: true,
        estimatedDeliveryDate: DateTime(bt.year, bt.month, bt.day),
      );
    } else {
      return DeliveryEstimate(
        type: DeliveryType.nextDay,
        title: 'Next Day Delivery',
        availabilityStatus: 'In Stock',
        cutoffNote: 'Same-day cutoff was 3:00 PM',
        isAvailable: true,
        estimatedDeliveryDate:
            DateTime(bt.year, bt.month, bt.day).add(const Duration(days: 1)),
      );
    }
  }

  /// Calculates the delivery summary for a collection of cart items.
  static CartDeliverySummary getCartDeliverySummary(
    List<CartItemModel> items, {
    DateTime? businessTime,
    bool isAlreadyBusinessTime = false,
  }) {
    if (items.isEmpty) {
      return const CartDeliverySummary(
        summaryLabel: 'No items in cart',
        slowestDeliveryType: DeliveryType.sameDay,
      );
    }

    final estimates = items
        .map((item) => getEstimate(
              item.product,
              businessTime: businessTime,
              isAlreadyBusinessTime: isAlreadyBusinessTime,
            ))
        .toList();

    bool hasTwoDays = estimates.any((e) => e.type == DeliveryType.twoDays);
    bool hasNextDay = estimates.any((e) => e.type == DeliveryType.nextDay);
    bool hasSameDay = estimates.any((e) => e.type == DeliveryType.sameDay);

    if (hasTwoDays) {
      final isMixed = hasSameDay || hasNextDay;
      return CartDeliverySummary(
        summaryLabel: 'Estimated complete delivery: Within 2 Days',
        secondaryNote: isMixed ? 'Some items will be delivered separately' : null,
        isMixed: isMixed,
        slowestDeliveryType: DeliveryType.twoDays,
      );
    }

    if (hasNextDay) {
      final isMixed = hasSameDay;
      return CartDeliverySummary(
        summaryLabel: 'Next Day Delivery',
        secondaryNote: isMixed ? 'Some items are eligible for same-day delivery' : null,
        isMixed: isMixed,
        slowestDeliveryType: DeliveryType.nextDay,
      );
    }

    return const CartDeliverySummary(
      summaryLabel: 'Same Day Delivery',
      isMixed: false,
      slowestDeliveryType: DeliveryType.sameDay,
    );
  }
}
