import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/voltspare_models.dart';

// Extension methods to serialize and deserialize backend JSON data to UI Models

extension VehicleBrandModelExtension on VehicleBrandModel {
  static VehicleBrandModel fromJson(Map<String, dynamic> json) {
    return VehicleBrandModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      logoAsset: json['logo']?.toString() ?? json['logoAsset']?.toString(),
    );
  }
}

extension VehicleModelExtension on VehicleModel {
  static VehicleModel fromJson(Map<String, dynamic> json) {
    final typeString = (json['type'] ?? 'Universal').toString().toLowerCase();
    final type =
        typeString.contains('ev') ? VehicleType.ev : VehicleType.petrol;

    String brandName = '';
    final brandVal = json['brand'];
    if (brandVal is Map) {
      brandName =
          brandVal['name']?.toString() ?? brandVal['_id']?.toString() ?? '';
    } else {
      brandName = brandVal?.toString() ?? '';
    }

    final yearVal = json['year'] ?? json['years'] ?? '';

    return VehicleModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      brand: brandName,
      name: (json['name'] ?? '').toString(),
      year: yearVal.toString(),
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
    if (json['image'] != null && json['image'].toString().isNotEmpty) {
      imageAsset = json['image'].toString();
    } else if (imageList.isNotEmpty) {
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
      fitmentBadge = vehicleTypeMap['name']?.toString() ??
          vehicleTypeMap['_id']?.toString();
    } else {
      fitmentBadge = vehicleTypeMap?.toString() ?? 'Universal';
    }

    final id = (json['_id'] ?? json['id'] ?? '').toString();
    final isWishlist = json['isLike'] == true ||
        json['islike'] == true ||
        json['is_like'] == true ||
        json['isLiked'] == true ||
        json['isliked'] == true ||
        json['is_liked'] == true ||
        json['isWishlist'] == true ||
        json['iswishlist'] == true ||
        json['is_wishlist'] == true ||
        json['isFavorite'] == true ||
        json['isfavorite'] == true ||
        json['is_favorite'] == true ||
        json['like'] == true ||
        json['liked'] == true ||
        (json['isLike'] != null && (json['isLike'] == 1 || json['isLike'] == 'true')) ||
        (json['islike'] != null && (json['islike'] == 1 || json['islike'] == 'true')) ||
        (json['isWishlist'] != null && (json['isWishlist'] == 1 || json['isWishlist'] == 'true'));

    final stockManagedRaw = json['stockManaged'];
    final bool stockManaged;
    if (stockManagedRaw != null) {
      stockManaged = stockManagedRaw == true ||
          stockManagedRaw == 'true' ||
          stockManagedRaw == 1;
    } else {
      // Legacy backward compatibility: default to true if any stock field is present or legacy product
      stockManaged = json['currentStock'] != null ||
          json['stock'] != null ||
          json['stockQuantity'] != null ||
          true;
    }

    final rawStock =
        json['currentStock'] ?? json['stock'] ?? json['stockQuantity'];
    final int? stockCount;
    if (stockManaged) {
      if (rawStock is num) {
        stockCount = rawStock.toInt();
      } else if (rawStock != null) {
        stockCount = int.tryParse(rawStock.toString()) ?? 10;
      } else {
        stockCount = 10;
      }
    } else {
      stockCount = null;
    }

    return ProductModel(
      id: id,
      name: json['name'] ?? '',
      price: pricePaise / 100.0,
      originalPrice: mrpPaise / 100.0,
      rating: (json['rating'] ?? 4.5).toDouble(),
      description: json['description'] ?? '',
      categoryId: categoryId,
      isWishlist: isWishlist,
      isFeatured: json['isFeatured'] ?? json['featured'] ?? false,
      compatibleVehicleIds: compatibleIds,
      fitmentBadge: fitmentBadge,
      imageAsset: imageAsset,
      stockCount: stockCount,
      stockManaged: stockManaged,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sellingPrice': (price * 100).toInt(),
      'mrp': originalPrice != null
          ? (originalPrice! * 100).toInt()
          : (price * 100).toInt(),
      'rating': rating,
      'description': description,
      'categoryId': categoryId,
      'isWishlist': isWishlist,
      'isFeatured': isFeatured,
      'compatibleVehicles': compatibleVehicleIds,
      'fitmentBadge': fitmentBadge,
      'image': imageAsset,
      'stockManaged': stockManaged,
      'stockQuantity': stockManaged ? stockCount : null,
      'currentStock': stockManaged ? stockCount : null,
    };
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
    final line1 = (json['addressLine1'] ?? json['addressLine'] ?? '').toString();
    final line2 = (json['addressLine2'] ?? '').toString();
    final city = (json['city'] ?? '').toString();
    var state = (json['state'] ?? '').toString();
    var postalCode = (json['postalCode'] ?? '').toString();

    // Clean any legacy dirty coordinates that may have been saved inside state or postalCode
    final latRegex = RegExp(r'\(Lat:\s*[0-9.-]+.*');
    if (latRegex.hasMatch(state)) {
      state = state.replaceAll(latRegex, '').trim();
    }
    if (postalCode.contains('Lng:') || postalCode.contains('Lat:')) {
      postalCode = '';
    }

    final parts = [
      if (line1.isNotEmpty) line1,
      if (line2.isNotEmpty) line2,
      if (city.isNotEmpty) city,
      if (state.isNotEmpty) state,
      if (postalCode.isNotEmpty) postalCode,
    ];

    final locMap = json['location'];
    String? locId = json['locationId']?.toString();
    String? locName = json['locationName']?.toString();
    double? distKm = json['distanceFromLocationKm'] != null
        ? (json['distanceFromLocationKm'] as num).toDouble()
        : null;

    if (locMap is Map) {
      locId ??= (locMap['id'] ?? locMap['_id'])?.toString();
      locName ??= locMap['name']?.toString();
      distKm ??= locMap['distanceKm'] != null
          ? (locMap['distanceKm'] as num).toDouble()
          : null;
    }

    return AddressModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: json['name'] ?? json['recipientName'] ?? 'Home',
      phone: json['phone'] ?? '',
      addressLine: parts.isEmpty ? (json['addressLine'] ?? '') : parts.join(', '),
      addressLine1: line1,
      addressLine2: line2,
      city: city,
      state: state,
      postalCode: postalCode,
      country: json['country']?.toString() ?? 'India',
      isDefault: json['isDefault'] ?? false,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      locationId: locId,
      locationName: locName,
      distanceFromLocationKm: distKm,
    );
  }

  Map<String, dynamic> toJson() {
    final line1 = (addressLine1 != null && addressLine1!.isNotEmpty)
        ? addressLine1!
        : (addressLine.isNotEmpty ? addressLine.split(',').first.trim() : 'Address');
    final line2 = addressLine2 ?? '';
    
    var cityName = (city != null && city!.isNotEmpty)
        ? city!
        : (addressLine.split(',').length > 2 ? addressLine.split(',')[2].trim() : 'Coimbatore');
    if (cityName.contains('(Lat:')) {
      cityName = cityName.split('(Lat:')[0].trim();
    }

    var stateName = (state != null && state!.isNotEmpty)
        ? state!
        : 'Tamil Nadu';
    if (stateName.contains('(Lat:')) {
      stateName = stateName.split('(Lat:')[0].trim();
    }
    if (stateName.isEmpty) stateName = 'Tamil Nadu';

    var pCode = (postalCode != null && postalCode!.isNotEmpty)
        ? postalCode!
        : '641001';
    if (pCode.contains('Lng:') || pCode.contains('Lat:')) {
      pCode = '641001';
    }
    // Retain only valid postal code characters (digits, letters, spaces)
    pCode = pCode.replaceAll(RegExp(r'[^0-9a-zA-Z -]'), '').trim();
    if (pCode.isEmpty) pCode = '641001';

    return {
      'name': name,
      'recipientName': name,
      'phone': phone,
      'addressLine1': line1.isEmpty ? 'Address' : line1,
      'addressLine2': line2,
      'city': cityName.isEmpty ? 'Coimbatore' : cityName,
      'state': stateName.isEmpty ? 'Tamil Nadu' : stateName,
      'postalCode': pCode,
      'country': country ?? 'India',
      'isDefault': isDefault,
      'latitude': latitude,
      'longitude': longitude,
      if (locationId != null) 'locationId': locationId,
      if (locationName != null) 'locationName': locationName,
      if (distanceFromLocationKm != null)
        'distanceFromLocationKm': distanceFromLocationKm,
    };
  }
}

extension OrderModelExtension on OrderModel {
  static OrderModel fromJson(Map<String, dynamic> json) {
    final statusString = (json['status'] ?? 'pending').toString().toLowerCase();
    OrderStatus status = OrderStatus.processing;
    if (statusString == 'shipped' || statusString == 'out_for_delivery') {
      status = OrderStatus.shipped;
    } else if (statusString == 'delivered') {
      status = OrderStatus.delivered;
    } else if (statusString == 'cancelled' || statusString == 'returned') {
      status = OrderStatus.cancelled;
    }

    final itemsList = json['items'] as List<dynamic>? ?? [];
    final items = itemsList.map((item) {
      final productMap = item['productSnapshot'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(item['productSnapshot'])
          : (item['productSnapshot'] is Map
              ? Map<String, dynamic>.from(item['productSnapshot'] as Map)
              : <String, dynamic>{});

      if (item['product'] is Map) {
        final pMap = item['product'] as Map<String, dynamic>;
        productMap['_id'] = (pMap['_id'] ?? pMap['id'] ?? '').toString();
        if (!productMap.containsKey('name') || productMap['name'] == null) {
          productMap['name'] = pMap['name'];
        }
        if (!productMap.containsKey('sellingPrice') ||
            productMap['sellingPrice'] == null) {
          productMap['sellingPrice'] = pMap['sellingPrice'];
        }
        if (!productMap.containsKey('images') || productMap['images'] == null) {
          productMap['images'] = pMap['images'];
        }
      } else if (item['product'] != null) {
        productMap['_id'] = item['product'].toString();
      }

      return CartItemModel(
        id: (item['_id'] ?? item['id'] ?? '').toString(),
        product: ProductModelExtension.fromJson(productMap),
        quantity: item['quantity'] is num ? (item['quantity'] as num).toInt() : 1,
      );
    }).toList();

    final addressMap = json['shippingAddress'] as Map<String, dynamic>? ?? {};
    final id = (json['_id'] ?? json['id'] ?? '').toString();
    final orderNumber = (json['orderNumber'] ??
        (id.isNotEmpty
            ? 'ORD-${id.substring(id.length > 6 ? id.length - 6 : 0).toUpperCase()}'
            : 'ORD-UNKNOWN')).toString();

    double parsePaise(dynamic val) {
      if (val is num) {
        return val.toDouble() / 100.0;
      }
      if (val != null) {
        final parsed = double.tryParse(val.toString());
        if (parsed != null) return parsed / 100.0;
      }
      return 0.0;
    }

    final double orderTotal = parsePaise(json['grandTotal'] ?? json['total']);
    final double subTotal = parsePaise(json['subTotal']);
    final double taxAmount = parsePaise(json['taxAmount']);
    final double deliveryFee = parsePaise(json['deliveryFee']);
    final double discountAmount = parsePaise(json['discountAmount']);

    final rawHistory = json['statusHistory'] as List<dynamic>? ?? [];
    final List<Map<String, dynamic>> statusHistory = rawHistory
        .map((h) => h is Map ? Map<String, dynamic>.from(h) : <String, dynamic>{})
        .toList();

    final deliveryAssignment = json['deliveryAssignment'] is Map
        ? Map<String, dynamic>.from(json['deliveryAssignment'] as Map)
        : null;

    return OrderModel(
      id: id,
      orderNumber: orderNumber,
      date: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      status: status,
      items: items,
      total: orderTotal,
      subTotal: subTotal,
      taxAmount: taxAmount,
      deliveryFee: deliveryFee,
      discountAmount: discountAmount,
      address: AddressModelExtension.fromJson(addressMap),
      paymentMethod: json['paymentMethod'] ?? 'Cash on Delivery',
      paymentStatus: json['paymentStatus']?.toString(),
      locationName: json['locationName']?.toString() ??
          (addressMap['locationName']?.toString()),
      statusHistory: statusHistory,
      deliveryAssignment: deliveryAssignment,
    );
  }
}

extension RareQuotationModelExtension on RareQuotationModel {
  static RareQuotationModel fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    final partName = itemsList.isNotEmpty
        ? (itemsList[0]['name'] ?? itemsList[0]['partName'] ?? '')
        : (json['partName'] ?? '');

    return RareQuotationModel(
      id: json['_id'] ?? json['id'] ?? '',
      partName: partName,
      price: (json['subTotal'] ?? 0) / 100.0,
      shippingCharge:
          (json['deliveryFee'] ?? json['shippingCharge'] ?? 0) / 100.0,
      gst: (json['taxAmount'] ?? json['gst'] ?? 0) / 100.0,
      discount: (json['discount'] ?? 0) / 100.0,
      grandTotal: (json['grandTotal'] ?? 0) / 100.0,
      deliveryTimeline: json['deliveryTimeline'] ?? '3-5 Days',
      expiryDate:
          DateTime.tryParse(json['expiresAt'] ?? json['expiryDate'] ?? '') ??
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

    final vehicleJson = json['vehicle'] is Map
        ? Map<String, dynamic>.from(json['vehicle'] as Map)
        : <String, dynamic>{};

    if ((vehicleJson['brand'] == null ||
            vehicleJson['brand'].toString().trim().isEmpty) &&
        json['vehicleBrand'] != null) {
      vehicleJson['brand'] = json['vehicleBrand'];
    }
    if ((vehicleJson['name'] == null ||
            vehicleJson['name'].toString().trim().isEmpty) &&
        (json['vehicleModel'] != null || json['modelName'] != null)) {
      vehicleJson['name'] = json['vehicleModel'] ?? json['modelName'];
    }
    if ((vehicleJson['year'] == null ||
            vehicleJson['year'].toString().trim().isEmpty) &&
        json['vehicleYear'] != null) {
      vehicleJson['year'] = json['vehicleYear'];
    }
    if ((vehicleJson['type'] == null ||
            vehicleJson['type'].toString().trim().isEmpty) &&
        json['vehicleType'] != null) {
      vehicleJson['type'] = json['vehicleType'];
    }

    final vehicle = VehicleModelExtension.fromJson(vehicleJson);

    final quotationJson = json['activeQuotation'] as Map<String, dynamic>?;
    final quotation = quotationJson != null
        ? RareQuotationModelExtension.fromJson(quotationJson)
        : null;

    final imageList = json['images'] as List<dynamic>? ?? [];

    final String customerName = (json['customerName'] != null && json['customerName'].toString().trim().isNotEmpty)
        ? json['customerName'].toString()
        : (json['user'] is Map ? (json['user']['name'] ?? 'Customer') : 'Customer');

    final String phone = (json['phone'] != null && json['phone'].toString().trim().isNotEmpty)
        ? json['phone'].toString()
        : (json['user'] is Map ? (json['user']['phone'] ?? '') : '');

    return RareProductRequestModel(
      id: json['_id'] ?? json['id'] ?? '',
      customerName: customerName,
      phone: phone,
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
      orderId: json['convertedOrder'] is Map
          ? (json['convertedOrder']['orderNumber'] ??
              json['convertedOrder']['_id']?.toString())
          : (json['convertedOrder']?.toString() ?? json['orderId']?.toString()),
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
