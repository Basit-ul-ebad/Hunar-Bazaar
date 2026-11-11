import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/l10n.dart';
import 'buyer_bottom_nav.dart';

/// Home · Listings · Orders · My shop. Pass [labels] to localise (Urdu).
class SellerBottomNav extends StatelessWidget {
  const SellerBottomNav({
    super.key,
    required this.current,
    required this.onSelected,
    this.labels,
    this.urdu = false,
  });

  final int current;
  final ValueChanged<int> onSelected;
  final List<String>? labels;
  final bool urdu;

  static const _icons = [
    Icons.home_outlined,
    Icons.grid_view_outlined,
    Icons.shopping_bag_outlined,
    Icons.storefront_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final t = context.l10n;
    final l =
        labels ??
        [t.sellerHome, t.sellerListings, t.sellerOrders, t.sellerMyShop];
    return BottomNavBar(
      items: [for (var i = 0; i < 4; i++) NavItem(_icons[i], l[i])],
      current: current,
      onSelected: onSelected,
      urdu: urdu,
      minItemWidth: 60,
    );
  }
}

/// Seller bottom-nav routing: Home, Listings (own shop), Orders, My shop.
class SellerNav {
  SellerNav._();

  static void go(BuildContext context, int i) => context.go(switch (i) {
    0 => '/seller',
    2 => '/seller/orders',
    _ => '/maker/me',
  });
}
