import 'package:flutter/material.dart';

enum AppTab { home, wishlist, cart, orders, profile }

enum ProductCategory { electronics, fashion, beauty, home, food }

enum ProductVisual { headphones, watch, sneakers, camera, backpack, sunglasses }

enum OrderStatusFilter { all, processing, shipped, delivered, cancelled }

enum PaymentMethod { upi, card, cashOnDelivery }

class ShopProduct {
  const ShopProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.visual,
    required this.category,
    required this.description,
    this.originalPrice,
    this.discountLabel,
    this.isFavorite = false,
    this.availableSizes = const <int>[],
    this.reviewCount = 0,
    this.highlight = '',
  });

  final String id;
  final String name;
  final double price;
  final double rating;
  final ProductVisual visual;
  final ProductCategory category;
  final String description;
  final double? originalPrice;
  final String? discountLabel;
  final bool isFavorite;
  final List<int> availableSizes;
  final int reviewCount;
  final String highlight;

  ShopProduct copyWith({
    String? id,
    String? name,
    double? price,
    double? rating,
    ProductVisual? visual,
    ProductCategory? category,
    String? description,
    double? originalPrice,
    String? discountLabel,
    bool? isFavorite,
    List<int>? availableSizes,
    int? reviewCount,
    String? highlight,
  }) {
    return ShopProduct(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      visual: visual ?? this.visual,
      category: category ?? this.category,
      description: description ?? this.description,
      originalPrice: originalPrice ?? this.originalPrice,
      discountLabel: discountLabel ?? this.discountLabel,
      isFavorite: isFavorite ?? this.isFavorite,
      availableSizes: availableSizes ?? this.availableSizes,
      reviewCount: reviewCount ?? this.reviewCount,
      highlight: highlight ?? this.highlight,
    );
  }
}

class CartEntry {
  const CartEntry({
    required this.id,
    required this.product,
    required this.quantity,
  });

  final String id;
  final ShopProduct product;
  final int quantity;

  CartEntry copyWith({
    String? id,
    ShopProduct? product,
    int? quantity,
  }) {
    return CartEntry(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}

class ShopOrder {
  const ShopOrder({
    required this.id,
    required this.orderNumber,
    required this.dateLabel,
    required this.itemCountLabel,
    required this.total,
    required this.status,
  });

  final String id;
  final String orderNumber;
  final String dateLabel;
  final String itemCountLabel;
  final double total;
  final OrderStatusFilter status;
}

class UserProfileData {
  const UserProfileData({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.imageUrl,
  });

  final String name;
  final String email;
  final String phone;
  final String address;
  final String? imageUrl;
}

class ProfileMenuItemData {
  const ProfileMenuItemData({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;
}
