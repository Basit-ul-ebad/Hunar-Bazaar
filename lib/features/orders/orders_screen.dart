import 'package:flutter/material.dart';
import '../../core/lang.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/seller_bottom_nav.dart';

/// Orders (`/seller/orders`). The prototype has no in-app checkout yet: buyers contact
/// makers directly on WhatsApp, so there are no orders to show. OWNER: Basit.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SellerBottomNav(
        current: 2,
        onSelected: (i) => SellerNav.go(context, i),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_bag_outlined, size: 48, color: AppColors.muted),
                const SizedBox(height: 12),
                Text(tr('No orders yet', 'ابھی کوئی آرڈر نہیں'), style: AppText.dm(18, weight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  tr(
                    'Buyers contact you directly on WhatsApp from your product page.',
                    'خریدار آپ کی پروڈکٹ کے صفحے سے سیدھا واٹس ایپ پر رابطہ کرتے ہیں۔',
                  ),
                  textAlign: TextAlign.center,
                  style: AppText.dm(14, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
