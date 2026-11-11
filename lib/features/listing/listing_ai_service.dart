import 'dart:typed_data';

/// What the AI returns for one product photo (both languages).
class ListingSuggestion {
  const ListingSuggestion({
    required this.titleEn,
    required this.titleUr,
    required this.storyEn,
    required this.storyUr,
    required this.craftMargin,
  });

  final String titleEn;
  final String titleUr;
  final String storyEn;
  final String storyUr;

  /// Craft margin from the AI; the app clamps it to 15–40 %.
  final double craftMargin;
}

/// Connect Gemini (Firebase AI Logic) by implementing this interface.
abstract class ListingAiService {
  /// Writes the listing from the photos. Must not set the price.
  Future<ListingSuggestion> generate(List<Uint8List> photos);

  /// Writes the story again (the "Write again" button).
  Future<ListingSuggestion> rewrite(List<Uint8List> photos);
}

/// Offline stand-in that returns the sample dupatta after a short delay.
class MockListingAiService implements ListingAiService {
  const MockListingAiService();

  static const _sample = ListingSuggestion(
    titleEn: 'Phulkari dupatta, hand-embroidered on khaddar',
    titleUr: 'کھدر پر ہاتھ سے کڑھائی والا پھلکاری دوپٹہ',
    storyEn:
        'Soft khaddar cotton, embroidered by hand with silk thread in the Punjabi bagh style. Each star is stitched one by one, so no two pieces are the same.',
    storyUr:
        'نرم کھدر کاٹن، پنجابی باغ انداز میں ریشمی دھاگے سے ہاتھ سے کڑھائی۔ ہر ستارہ ایک ایک کر کے کاڑھا جاتا ہے، اس لیے کوئی دو ٹکڑے ایک جیسے نہیں ہوتے۔',
    craftMargin: 0.30,
  );

  @override
  Future<ListingSuggestion> generate(List<Uint8List> photos) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    return _sample;
  }

  @override
  Future<ListingSuggestion> rewrite(List<Uint8List> photos) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _sample;
  }
}

/// The one AI service the app uses. Swap for the Gemini implementation later.
ListingAiService listingAi = const MockListingAiService();
