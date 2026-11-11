import 'dart:typed_data';

/// Result of the Gemini listing call (matches the JSON schema in the prompt). OWNER: Basit.
class ListingDraft {
  final String category;
  final String titleEn, titleUr, descEn, descUr;
  final List<String> features, tags;
  final String craftsmanship; // basic | good | excellent
  final double marketMultiplier;
  final String reasonEn, reasonUr;
  final String comparablesNote;
  const ListingDraft({
    required this.category,
    required this.titleEn,
    required this.titleUr,
    required this.descEn,
    required this.descUr,
    required this.features,
    required this.tags,
    required this.craftsmanship,
    required this.marketMultiplier,
    required this.reasonEn,
    required this.reasonUr,
    this.comparablesNote = '',
  });
}

abstract class GeminiService {
  Future<ListingDraft> generateListing({
    required Uint8List imageBytes,
    required String city,
    required double materialsCost,
    required double hours,
    String notes = '',
  });
}

/// Canned response so the sell flow UI can be built before Gemini is wired up.
class FakeGeminiService implements GeminiService {
  @override
  Future<ListingDraft> generateListing({
    required Uint8List imageBytes,
    required String city,
    required double materialsCost,
    required double hours,
    String notes = '',
  }) async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return const ListingDraft(
      category: 'Embroidery',
      titleEn: 'Hand-Embroidered Cotton Dupatta',
      titleUr: 'ہاتھ سے کڑھائی والا سوتی دوپٹہ',
      descEn:
          'A soft cotton dupatta with detailed floral thread embroidery along the border, made entirely by hand.',
      descUr: 'نرم سوتی دوپٹہ جس کے کنارے پر پھولوں کی باریک کڑھائی ہاتھ سے کی گئی ہے۔',
      features: ['Hand embroidered', 'Soft cotton fabric', 'Floral border', 'Colour-fast thread'],
      tags: ['dupatta', 'embroidery', 'handmade', 'cotton', 'gift'],
      craftsmanship: 'good',
      marketMultiplier: 1.15,
      reasonEn: 'Neat, dense stitching and strong demand for embroidered dupattas in your city.',
      reasonUr: 'صاف اور گھنی کڑھائی ہے اور آپ کے شہر میں کڑھائی والے دوپٹوں کی مانگ زیادہ ہے۔',
      comparablesNote: 'Similar items sell for roughly Rs 2,500-4,500 (sample data).',
    );
  }
}

/// The app uses this. Basit swaps in the real Firebase AI Logic implementation later.
GeminiService geminiService = FakeGeminiService();
