import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/lang.dart';
import '../core/seller_profile.dart';
import 'buyer_bottom_nav.dart';

/// The one bottom bar for the whole app (same for buyers and sellers). OWNER: Basit.
/// 0 Explore (all products) · 1 Makers · 2 Sell (dashboard, or set up a shop) · 3 My shop.
class AppNav extends StatelessWidget {
  const AppNav({super.key, required this.current});
  final int current;

  static bool get _hasShop => sellerProfile.shopName.trim().isNotEmpty;

  static void go(BuildContext context, int i) => context.go(switch (i) {
    0 => '/',
    1 => '/makers',
    2 => _hasShop ? '/seller' : '/sell',
    _ => _hasShop ? '/maker/me' : '/sell',
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavBar(
      items: [
        NavItem(Icons.home_outlined, tr('Explore', 'دریافت')),
        NavItem(Icons.groups_outlined, tr('Makers', 'کاریگر')),
        NavItem(Icons.add_circle_outline, tr('Sell', 'بیچیں')),
        NavItem(Icons.storefront_outlined, tr('My shop', 'میری دکان')),
      ],
      current: current,
      onSelected: (i) => go(context, i),
      urdu: isUrdu.value,
    );
  }
}
