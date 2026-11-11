import 'package:flutter/material.dart';
import '../../core/lang.dart';

/// Seller's own shop: her listings + shareable link. OWNER: UI partner.
/// TODO(partner): show the signed-in seller's listings with ListingCard.
class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('My shop', 'میری دکان'))),
      body: const Center(child: Text('TODO: my shop')),
    );
  }
}
