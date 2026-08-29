import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';

// Extension methods to serialize and deserialize backend JSON data to UI Models

extension VehicleBrandModelExtension on VehicleBrandModel {
  static VehicleBrandModel fromJson(Map<String, dynamic> json) {
    return VehicleBrandModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      logoAsset: json['logo'] ?? json['logoAsset'],
    );
  }
}

extension VehicleModelExtension on VehicleModel {
  static VehicleModel fromJson(Map<String, dynamic> json) {
    final typeString = (json['type'] ?? 'Universal').toString().toLowerCase();
    final type =
        typeString.contains('ev') ? VehicleType.ev : VehicleType.petrol;

    return VehicleModel(
      id: json['_id'] ?? json['id'] ?? '',
      brand: json['brand'] ?? '',
      name: json['name'] ?? '',
      year: json['year']?.toString() ?? '',
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'name': name,
      'year': year,
      'type': type == VehicleType.ev ? 'EV' : 'Petrol',
    };
  }
}

extension CategoryModelExtension on CategoryModel {
  static CategoryModel fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      icon: _getIconForCategory(json['name'] ?? ''),
    );
  }

  static IconData _getIconForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('engine')) return Icons.settings;
    if (lower.contains('brake')) return Icons.stop_circle;
    if (lower.contains('electrical') ||
        lower.contains('battery') ||
        lower.contains('plug')) {
      return Icons.electric_bolt;
    }
    if (lower.contains('body')) return Icons.directions_bike;
    return Icons.build;
  }
}

extension ProductModelExtension on ProductModel {
  static ProductModel fromJson(Map<String, dynamic> json) {
    // backend sellingPrice is in paise (int). UI expects double in rupees.
    final pricePaise = json['sellingPrice'] ?? 0;
    final mrpPaise = json['mrp'] ?? pricePaise;

    final imageList = json['images'] as List<dynamic>? ?? [];
    String? imageAsset;
    if (imageList.isNotEmpty) {
      final firstImage = imageList[0];
      if (firstImage is Map) {
        imageAsset = (firstImage['url'] ?? firstImage['path'] ?? '').toString();
      } else {
        imageAsset = firstImage?.toString();
      }
    }

    final categoryMap = json['category'];
    String categoryId = '';
    if (categoryMap is Map) {
      categoryId = categoryMap['_id'] ?? categoryMap['id'] ?? '';
    } else {
      categoryId = categoryMap?.toString() ?? '';
    }

    final compVehicles = json['compatibleVehicles'] as List<dynamic>? ?? [];
    final List<String> compatibleIds = compVehicles.map((v) {
      if (v is Map) return (v['_id'] ?? v['id'] ?? '').toString();
      return v.toString();
    }).toList();

    final vehicleTypeMap = json['vehicleType'];
    String? fitmentBadge;
    if (vehicleTypeMap is Map) {
      fitmentBadge = vehicleTypeMap['name']?.toString() ?? vehicleTypeMap['_id']?.toString();
    } else {
      fitmentBadge = vehicleTypeMap?.toString() ?? 'Universal';
    }

    return ProductModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      price: pricePaise / 100.0,
      originalPrice: mrpPaise / 100.0,
      rating: (json['rating'] ?? 4.5).toDouble(),
      description: json['description'] ?? '',
      categoryId: categoryId,
      isFavorite: json['isFavorite'] ?? false,
      isFeatured: json['isFeatured'] ?? json['featured'] ?? false,
      compatibleVehicleIds: compatibleIds,
      fitmentBadge: fitmentBadge,
      imageAsset: imageAsset,
      stockCount: json['currentStock'] ?? 10,
    );
  }
}

extension CartItemModelExtension on CartItemModel {
  static CartItemModel fromJson(Map<String, dynamic> json) {
    final productMap = json['product'] as Map<String, dynamic>? ?? {};
    return CartItemModel(
      id: json['_id'] ?? json['id'] ?? '',
      product: ProductModelExtension.fromJson(productMap),
      quantity: json['quantity'] ?? 1,
    );
  }
}

extension AddressModelExtension on AddressModel {
  static AddressModel fromJson(Map<String, dynamic> json) {
    final line1 = json['addressLine1'] ?? json['addressLine'] ?? '';
    final line2 = json['addressLine2'] ?? '';
    final city = json['city'] ?? '';
    final state = json['state'] ?? '';
    final postalCode = json['postalCode'] ?? '';

    final parts = [
      if (line1.isNotEmpty) line1,
      if (line2.isNotEmpty) line2,
      if (city.isNotEmpty) city,
      if (state.isNotEmpty) state,
      if (postalCode.isNotEmpty) postalCode,
    ];

    return AddressModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? 'Home',
      phone: json['phone'] ?? '',
      addressLine: parts.isEmpty ? '' : parts.join(', '),
      isDefault: json['isDefault'] ?? false,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final parts = addressLine.split(',');
    final line1 = parts.isNotEmpty ? parts[0].trim() : addressLine;
    final line2 = parts.length > 1 ? parts[1].trim() : '';
    final city = parts.length > 2 ? parts[2].trim() : 'Bangalore';
    final state = parts.length > 3 ? parts[3].trim() : 'Karnataka';
    final postalCode = parts.length > 4 ? parts[4].trim() : '560001';

    return {
      'name': name,
      'recipientName': name,
      'phone': phone,
      'addressLine1': line1.isEmpty ? 'Address' : line1,
      'addressLine2': line2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'country': 'India',
      'isDefault': isDefault,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

extension OrderModelExtension on OrderModel {
  static OrderModel fromJson(Map<String, dynamic> json) {
    final statusString = (json['status'] ?? 'pending').toString().toLowerCase();
    OrderStatus status = OrderStatus.processing;
    if (statusString == 'shipped') {
      status = OrderStatus.shipped;
    } else if (statusString == 'delivered') {
      status = OrderStatus.delivered;
    } else if (statusString == 'cancelled') {
      status = OrderStatus.cancelled;
    }

    final itemsList = json['items'] as List<dynamic>? ?? [];
    final items = itemsList.map((item) {
      final productMap = item['productSnapshot'] ?? {};
      productMap['_id'] = item['product']; // Map product ID correctly
      return CartItemModel(
        id: item['_id'] ?? item['id'] ?? '',
        product: ProductModelExtension.fromJson(productMap),
        quantity: item['quantity'] ?? 1,
      );
    }).toList();

    final addressMap = json['shippingAddress'] as Map<String, dynamic>? ?? {};

    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      date: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      status: status,
      items: items,
      total: (json['grandTotal'] ?? 0) / 100.0,
      address: AddressModelExtension.fromJson(addressMap),
      paymentMethod: json['paymentMethod'] ?? 'cod',
    );
  }
}

extension RareQuotationModelExtension on RareQuotationModel {
  static RareQuotationModel fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    final partName =
        itemsList.isNotEmpty ? (itemsList[0]['partName'] ?? '') : '';

    return RareQuotationModel(
      id: json['_id'] ?? json['id'] ?? '',
      partName: partName,
      price: (json['subTotal'] ?? 0) / 100.0,
      shippingCharge: (json['shippingCharge'] ?? 0) / 100.0,
      gst: (json['gst'] ?? 0) / 100.0,
      discount: (json['discount'] ?? 0) / 100.0,
      grandTotal: (json['grandTotal'] ?? 0) / 100.0,
      deliveryTimeline: json['deliveryTimeline'] ?? '3-5 Days',
      expiryDate: DateTime.tryParse(json['expiryDate'] ?? '') ??
          DateTime.now().add(const Duration(days: 7)),
      adminNotes: json['adminNotes'],
      status: json['status'] ?? 'pending',
    );
  }
}

extension RareProductRequestModelExtension on RareProductRequestModel {
  static RareProductRequestModel fromJson(Map<String, dynamic> json) {
    final statusString = (json['status'] ?? 'submitted').toString();
    RareRequestStatus status = RareRequestStatus.submitted;
    if (statusString == 'searching') {
      status = RareRequestStatus.searching;
    } else if (statusString == 'found') {
      status = RareRequestStatus.found;
    } else if (statusString == 'quotation_sent') {
      status = RareRequestStatus.quotationSent;
    } else if (statusString == 'negotiation') {
      status = RareRequestStatus.negotiation;
    } else if (statusString == 'approved') {
      status = RareRequestStatus.approved;
    } else if (statusString == 'cancelled') {
      status = RareRequestStatus.cancelled;
    } else if (statusString == 'converted_to_order') {
      status = RareRequestStatus.convertedToOrder;
    }

    final vehicleJson = json['vehicle'] as Map<String, dynamic>? ?? {};
    final vehicle = VehicleModelExtension.fromJson(vehicleJson);

    final quotationJson = json['activeQuotation'] as Map<String, dynamic>?;
    final quotation = quotationJson != null
        ? RareQuotationModelExtension.fromJson(quotationJson)
        : null;

    final imageList = json['images'] as List<dynamic>? ?? [];

    return RareProductRequestModel(
      id: json['_id'] ?? json['id'] ?? '',
      customerName: json['user'] is Map ? (json['user']['name'] ?? '') : '',
      phone: json['user'] is Map ? (json['user']['phone'] ?? '') : '',
      vehicle: vehicle,
      partName: json['title'] ?? '',
      description: json['description'] ?? '',
      quantity: json['quantity'] ?? 1,
      urgency: json['urgency'] ?? 'medium',
      budget: json['budget'] != null ? (json['budget'] / 100.0) : null,
      images: imageList
          .map((im) => im is Map ? (im['url'] ?? '').toString() : im.toString())
          .toList(),
      notes: json['notes'],
      status: status,
      date: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      quotation: quotation,
      cancellationReason: json['cancellationReason'],
      orderId: json['orderId'],
    );
  }
}

extension RareChatMessageModelExtension on RareChatMessageModel {
  static RareChatMessageModel fromJson(Map<String, dynamic> json) {
    final senderString = (json['senderType'] ?? 'system').toString();
    RareChatSender sender = RareChatSender.system;
    if (senderString == 'customer') {
      sender = RareChatSender.customer;
    } else if (senderString == 'admin') {
      sender = RareChatSender.admin;
    }

    final typeString = (json['messageType'] ?? 'text').toString();
    RareChatMessageType messageType = RareChatMessageType.text;
    if (typeString == 'image') {
      messageType = RareChatMessageType.image;
    } else if (typeString == 'quotation') {
      messageType = RareChatMessageType.quotation;
    } else if (typeString == 'status_update') {
      messageType = RareChatMessageType.statusUpdate;
    } else if (typeString == 'product_found') {
      messageType = RareChatMessageType.productFound;
    }

    final imagesList = <String>[];
    if (json['images'] is List) {
      imagesList.addAll((json['images'] as List).map((e) => e.toString()));
    } else if (json['imageUrl'] != null) {
      imagesList.add(json['imageUrl'].toString());
    }

    final quotationMap = json['quotation'] as Map<String, dynamic>?;
    final quotation = quotationMap != null
        ? RareQuotationModelExtension.fromJson(quotationMap)
        : null;

    final readByList =
        (json['readBy'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
            <String>[];
    final receivedByList = (json['receivedBy'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];

    return RareChatMessageModel(
      id: json['_id'] ?? json['id'] ?? '',
      message: json['message'] ?? '',
      sender: sender,
      timestamp: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      messageType: messageType,
      images: imagesList,
      quotation: quotation,
      readBy: readByList,
      receivedBy: receivedByList,
    );
  }
}

extension SupplierModelExtension on SupplierModel {
  static SupplierModel fromJson(Map<String, dynamic> json) {
    final compList = json['categories'] as List<dynamic>? ?? [];
    final List<String> cats = compList.map((c) => c.toString()).toList();

    return SupplierModel(
      id: json['_id'] ?? json['id'] ?? '',
      companyName: json['companyName'] ?? '',
      contactPerson: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      gstNumber: json['gstNumber'] ?? '',
      categories: cats,
      suppliesEvParts: json['suppliesEvParts'] ?? true,
      suppliesPetrolParts: json['suppliesPetrolParts'] ?? true,
      isActive: json['active'] ?? true,
      outstandingAmountInPaise: json['outstandingBalance'] ?? 0,
      lastPurchaseDate: DateTime.tryParse(json['updatedAt'] ?? ''),
    );
  }
}
