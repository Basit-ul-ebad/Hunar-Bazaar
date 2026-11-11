import 'package:flutter/material.dart';
import '../../core/lang.dart';

/// Seller flow: photo -> details -> AI listing + price -> publish. OWNER: UI partner (UI), Basit (AI wiring).
/// TODO(partner): build the form UI: photo picker, hours, materials cost, city dropdown (kCityNames), notes.
/// Call `geminiService.generateListing(...)` (lib/core/gemini_service.dart) - it returns a fake draft for now.
/// Then show the draft + price from `computePrice(...)` (lib/core/pricing.dart) and a Publish button.
class SellScreen extends StatelessWidget {
  const SellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('Sell your product', 'اپنی چیز بیچیں'))),
      body: const Center(child: Text('TODO: seller flow')),
    );
  }
}
