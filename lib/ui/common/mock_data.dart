import 'package:flutter/material.dart';
import 'package:spare_shop/ui/common/shop_models.dart';

const kDeliveryNote = 'Free Delivery   -   7 Days Return   -   100% Original';

const kCategories = <ProductCategory>[
  ProductCategory.electronics,
  ProductCategory.fashion,
  ProductCategory.beauty,
  ProductCategory.home,
  ProductCategory.food,
];

const _featuredProducts = <ShopProduct>[
  ShopProduct(
    id: 'headphones',
    name: 'Wireless Headphones',
    price: 1999,
    rating: 4.8,
    visual: ProductVisual.headphones,
    category: ProductCategory.electronics,
    description:
        'Immersive sound with a feather-light fit for work, travel, and daily playlists.',
    highlight: 'Top Seller',
  ),
  ShopProduct(
    id: 'watch',
    name: 'Smart Watch',
    price: 2499,
    rating: 4.7,
    visual: ProductVisual.watch,
    category: ProductCategory.electronics,
    description:
        'A crisp AMOLED face, health tracking, and week-long battery in a sleek frame.',
    highlight: 'Fresh Drop',
  ),
  ShopProduct(
    id: 'sneakers',
    name: 'Nike Air Max 270',
    price: 2999,
    originalPrice: 4999,
    discountLabel: '40% OFF',
    rating: 4.8,
    reviewCount: 120,
    visual: ProductVisual.sneakers,
    category: ProductCategory.fashion,
    description:
        'Experience unbeatable comfort and style with the Nike Air Max 270. Perfect for any occasion.',
    availableSizes: <int>[6, 7, 8, 9, 10, 11],
    highlight: 'Editor Pick',
  ),
];

const _wishlistProducts = <ShopProduct>[
  ShopProduct(
    id: 'camera',
    name: 'Camera',
    price: 4999,
    rating: 4.6,
    visual: ProductVisual.camera,
    category: ProductCategory.electronics,
    description: 'Capture crisp moments with a compact street-ready camera.',
    isFavorite: true,
  ),
  ShopProduct(
    id: 'backpack',
    name: 'Backpack',
    price: 1299,
    rating: 4.7,
    visual: ProductVisual.backpack,
    category: ProductCategory.fashion,
    description: 'A spacious everyday backpack with padded comfort straps.',
    isFavorite: true,
  ),
  ShopProduct(
    id: 'sunglasses',
    name: 'Sunglasses',
    price: 899,
    rating: 4.5,
    visual: ProductVisual.sunglasses,
    category: ProductCategory.fashion,
    description: 'Lightweight frames with glare-cutting lenses for sunny days.',
    isFavorite: true,
  ),
  ShopProduct(
    id: 'watch-favorite',
    name: 'Smart Watch',
    price: 2499,
    rating: 4.7,
    visual: ProductVisual.watch,
    category: ProductCategory.electronics,
    description: 'Stylish health tracking with just-right daily essentials.',
    isFavorite: true,
  ),
];

final _cartEntries = <CartEntry>[
  CartEntry(id: 'cart-1', product: _featuredProducts[0], quantity: 1),
  CartEntry(id: 'cart-2', product: _featuredProducts[1], quantity: 1),
  CartEntry(id: 'cart-3', product: _featuredProducts[2], quantity: 1),
];

const _orders = <ShopOrder>[
  ShopOrder(
    id: 'order-1',
    orderNumber: '#12345',
    dateLabel: '20 May 2024',
    itemCountLabel: '3 items',
    total: 6797,
    status: OrderStatusFilter.delivered,
  ),
  ShopOrder(
    id: 'order-2',
    orderNumber: '#12344',
    dateLabel: '18 May 2024',
    itemCountLabel: '2 items',
    total: 3998,
    status: OrderStatusFilter.shipped,
  ),
  ShopOrder(
    id: 'order-3',
    orderNumber: '#12343',
    dateLabel: '15 May 2024',
    itemCountLabel: '1 item',
    total: 2299,
    status: OrderStatusFilter.processing,
  ),
];

const mockUserProfile = UserProfileData(
  name: 'Sangavi',
  email: 'sangavi@example.com',
  phone: '+91 98765 43210',
  address: '123, Main Street, Coimbatore, Tamil Nadu - 641001',
);

const profileMenuItems = <ProfileMenuItemData>[
  ProfileMenuItemData(title: 'My Addresses', icon: Icons.location_on_outlined),
  ProfileMenuItemData(title: 'Order History', icon: Icons.receipt_long_rounded),
  ProfileMenuItemData(
      title: 'My Rare Requests', icon: Icons.build_circle_outlined),
  ProfileMenuItemData(
    title: 'Payment Methods',
    icon: Icons.credit_card_rounded,
  ),
  ProfileMenuItemData(title: 'Settings', icon: Icons.settings_outlined),
  ProfileMenuItemData(title: 'Logout', icon: Icons.logout_rounded),
];

List<ShopProduct> mockFeaturedProducts() =>
    _featuredProducts.map((product) => product.copyWith()).toList();

List<ShopProduct> mockWishlistProducts() =>
    _wishlistProducts.map((product) => product.copyWith()).toList();

List<CartEntry> mockCartEntries() => _cartEntries
    .map(
      (entry) => CartEntry(
        id: entry.id,
        product: entry.product.copyWith(),
        quantity: entry.quantity,
      ),
    )
    .toList();

List<ShopOrder> mockOrders() => List<ShopOrder>.from(_orders);

ShopProduct defaultProductDetails() => _featuredProducts[2].copyWith(
      isFavorite: true,
    );
