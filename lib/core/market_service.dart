import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

import 'cities.dart';
import 'gemini_listing_ai.dart' show kGeminiModels;
import 'seller_profile.dart';

/// How the seller's local market shifts the fair price. OWNER: Basit.
/// multiplier 1.0 = national average; the app multiplies the fair price by it.
class MarketInfo {
  const MarketInfo({
    required this.multiplier,
    required this.noteEn,
    required this.noteUr,
    required this.fromSearch,
  });
  final double multiplier;
  final String noteEn;
  final String noteUr;

  /// true = found with Gemini + Google Search; false = built-in city tier table.
  final bool fromSearch;
}

/// Offline fallback from the seeded city table (cities.dart).
MarketInfo tierFallback(String city) {
  final key = cityKey(city);
  final m = fallbackMultiplier(key);
  final en = (m - 1).abs() < 0.005
      ? 'Priced at the national average for $key.'
      : 'Adjusted for the $key market (${m > 1 ? 'higher' : 'lower'} demand and costs).';
  return MarketInfo(
    multiplier: m,
    noteEn: en,
    noteUr: 'آپ کے شہر ($key) کی مارکیٹ کے مطابق قیمت ایڈجسٹ کی گئی۔',
    fromSearch: false,
  );
}

/// Asks Gemini (with Google Search grounding) how the seller's city prices this kind of item.
/// Never throws: falls back to [tierFallback].
Future<MarketInfo> fetchMarket({
  required String city,
  required String product,
}) async {
  final key = cityKey(city);
  final fallback = tierFallback(city);
  if (product.trim().isEmpty) return fallback;

  final prompt =
      '''
You are a market researcher for Pakistani handmade goods.
Product: $product. Seller city: $key, Pakistan.
Search for typical selling prices in PKR of comparable handmade items in or near $key
(Daraz, Instagram boutiques, local bazaars) and compare with the national average.
Reply in EXACTLY this format, nothing else:
MULTIPLIER: <a number from 0.85 to 1.25; below 1 means $key pays less than the national average for this item, above 1 means more; 1.0 if you find no reliable data>
WHY: <one short plain sentence a seller can understand>
Do not invent prices.''';

  for (final name in kGeminiModels) {
    try {
      final model = FirebaseAI.googleAI().generativeModel(
        model: name,
        tools: [Tool.googleSearch()],
      );
      final res = await model
          .generateContent([Content.text(prompt)])
          .timeout(const Duration(seconds: 25));
      final text = res.text ?? '';
      final m = RegExp(r'MULTIPLIER:\s*([0-9]+(?:\.[0-9]+)?)').firstMatch(text);
      if (m == null) continue;
      final v = double.parse(m.group(1)!).clamp(0.85, 1.25).toDouble();
      final why = RegExp(r'WHY:\s*(.+)').firstMatch(text)?.group(1)?.trim() ?? '';
      debugPrint('[HB] Market lookup OK via Google Search (model: $name): x$v for $key');
      return MarketInfo(
        multiplier: v,
        noteEn: why.isEmpty ? fallback.noteEn : why,
        noteUr: fallback.noteUr,
        fromSearch: true,
      );
    } catch (e) {
      debugPrint('Market lookup with "$name" failed: $e');
    }
  }
  debugPrint('[HB] Market lookup fell back to city table for $key');
  return fallback;
}
