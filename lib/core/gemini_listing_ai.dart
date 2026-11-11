import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';

import '../features/listing/listing_ai_service.dart';

/// Real Gemini implementation of the UI's [ListingAiService] (Firebase AI Logic, no API key in the app).
/// OWNER: Basit. The price is NOT written here - it is calculated in code (pricing_calc.dart).
///
/// Model names are tried in order until one works; the working one is remembered.
/// If Gemini rejects all of them, check the model list in Firebase console > AI Logic and edit [kGeminiModels].
const List<String> kGeminiModels = [
  'gemini-2.5-flash',
  'gemini-3-flash-preview',
  'gemini-2.0-flash',
];

class GeminiListingAiService implements ListingAiService {
  GeminiListingAiService();

  String? _workingModel;

  static final Schema _schema = Schema.object(
    properties: {
      'titleEn': Schema.string(description: 'Product title in English, max 12 words'),
      'titleUr': Schema.string(description: 'Same title in simple Urdu'),
      'storyEn': Schema.string(description: 'Short product story in English, 2-3 sentences'),
      'storyUr': Schema.string(description: 'Same story in simple Urdu'),
      'craftMargin': Schema.number(
        description: 'Craftsmanship margin from 0.15 (basic) to 0.40 (exceptional)',
      ),
    },
  );

  static const String _prompt = '''
You help home-based women artisans in Pakistan sell their handmade work.
Look at the product photos and write the listing.
- Describe ONLY what is visible: craft, technique, materials, colours, style. Do not invent materials, sizes or claims.
- titleEn / titleUr: a clear product title.
- storyEn / storyUr: 2-3 warm, honest sentences a buyer would enjoy. Urdu must be simple and natural.
- craftMargin: a number between 0.15 and 0.40 based ONLY on the visible craftsmanship
  (0.15 basic, 0.25 good, 0.35 excellent, 0.40 exceptional).
- Never mention a price.
Return JSON only.''';

  @override
  Future<ListingSuggestion> generate(List<Uint8List> photos) =>
      _run(photos, rewrite: false);

  @override
  Future<ListingSuggestion> rewrite(List<Uint8List> photos) =>
      _run(photos, rewrite: true);

  Future<ListingSuggestion> _run(
    List<Uint8List> photos, {
    required bool rewrite,
  }) async {
    if (photos.isEmpty) throw ArgumentError('At least one photo is required');

    final prompt = rewrite
        ? '$_prompt\nWrite the story again with different wording and a fresh angle.'
        : _prompt;
    final parts = <Part>[
      TextPart(prompt),
      for (final p in photos.take(4)) InlineDataPart(_mime(p), p),
    ];

    final names = _workingModel != null ? [_workingModel!] : kGeminiModels;
    Object? lastError;
    for (final name in names) {
      try {
        final model = FirebaseAI.googleAI().generativeModel(
          model: name,
          generationConfig: GenerationConfig(
            responseMimeType: 'application/json',
            responseSchema: _schema,
            temperature: rewrite ? 0.9 : 0.5,
          ),
        );
        final res = await model
            .generateContent([Content.multi(parts)])
            .timeout(const Duration(seconds: 45));
        final text = res.text;
        if (text == null || text.trim().isEmpty) {
          throw StateError('Gemini returned an empty response');
        }
        final j = jsonDecode(text) as Map<String, dynamic>;
        _workingModel = name;
        debugPrint('[HB] Gemini listing text OK (model: $name)');
        return ListingSuggestion(
          titleEn: (j['titleEn'] ?? '').toString().trim(),
          titleUr: (j['titleUr'] ?? '').toString().trim(),
          storyEn: (j['storyEn'] ?? '').toString().trim(),
          storyUr: (j['storyUr'] ?? '').toString().trim(),
          craftMargin:
              ((j['craftMargin'] as num?)?.toDouble() ?? 0.25).clamp(0.15, 0.40).toDouble(),
        );
      } catch (e) {
        lastError = e;
        debugPrint('Gemini model "$name" failed: $e');
      }
    }
    throw Exception('Gemini failed on all models: $lastError');
  }

  /// image_picker returns JPEG or PNG; sniff the header.
  static String _mime(Uint8List b) =>
      (b.length > 3 && b[0] == 0x89 && b[1] == 0x50) ? 'image/png' : 'image/jpeg';
}
