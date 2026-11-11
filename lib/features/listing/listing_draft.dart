import 'package:flutter/foundation.dart';
import '../../core/market_service.dart';
import '../../core/seller_profile.dart';
import 'listing_ai_service.dart';
import 'pricing_calc.dart';

/// The product being listed. Lives outside the widgets so it survives a
/// language switch and every step of the flow shares it.
class ListingDraft extends ChangeNotifier {
  static const maxPhotos = 5;

  /// Photos picked by the maker (bytes work on mobile and web).
  final List<Uint8List> photos = [];
  int selectedPhoto = 0;

  String titleEn = '';
  String titleUr = '';
  String storyEn = '';
  String storyUr = '';
  double craftMargin = 0.30;

  /// Local market multiplier and why (see core/market_service.dart).
  double market = 1.0;
  String marketNoteEn = '';
  String marketNoteUr = '';
  String _marketFor = '';

  int materials = 0;
  int days = 1;
  int userPrice = 0; // 0 = the maker has not typed her own price yet

  /// The price she typed, or the calculated fair price if she did not choose one.
  int get finalPrice => userPrice > 0 ? userPrice : suggestion.fair;

  int get hours => days * kHoursPerDay;

  PriceSuggestion get suggestion =>
      suggestPrice(
        materials: materials,
        hours: hours,
        margin: craftMargin,
        market: market,
      );

  bool get hasPhoto => photos.isNotEmpty;
  Uint8List? get selected =>
      photos.isEmpty ? null : photos[selectedPhoto.clamp(0, photos.length - 1)];

  void addPhotos(Iterable<Uint8List> more) {
    for (final p in more) {
      if (photos.length >= maxPhotos) break;
      photos.add(p);
      selectedPhoto = photos.length - 1;
    }
    notifyListeners();
  }

  /// Removes photo [i] (the maker picked the wrong one).
  void removePhoto(int i) {
    if (i < 0 || i >= photos.length) return;
    photos.removeAt(i);
    if (photos.isEmpty) {
      selectedPhoto = 0;
    } else if (i < selectedPhoto || selectedPhoto >= photos.length) {
      selectedPhoto = (selectedPhoto - 1).clamp(0, photos.length - 1);
    }
    notifyListeners();
  }

  void selectPhoto(int i) {
    selectedPhoto = i;
    notifyListeners();
  }

  void apply(ListingSuggestion s) {
    titleEn = s.titleEn;
    titleUr = s.titleUr;
    storyEn = s.storyEn;
    storyUr = s.storyUr;
    craftMargin = s.craftMargin;
    _refreshMarket(s.titleEn);
    notifyListeners();
  }

  String get cityName => cityKey(sellerProfile.city);

  /// Instant city-tier estimate, then Gemini + Google Search refines it in the background.
  void _refreshMarket(String product) {
    if (product == _marketFor) return;
    _marketFor = product;
    final fb = tierFallback(sellerProfile.city);
    market = fb.multiplier;
    marketNoteEn = fb.noteEn;
    marketNoteUr = fb.noteUr;
    fetchMarket(city: sellerProfile.city, product: product).then((m) {
      if (_marketFor != product) return;
      market = m.multiplier;
      marketNoteEn = m.noteEn;
      marketNoteUr = m.noteUr;
      notifyListeners();
    });
  }

  void setMaterials(int v) {
    materials = v;
    notifyListeners();
  }

  void setDays(int v) {
    days = v.clamp(1, 30);
    notifyListeners();
  }

  void setUserPrice(int v) {
    userPrice = v;
    notifyListeners();
  }

  /// Back to a blank flow ("Add another product").
  void reset() {
    photos.clear();
    selectedPhoto = 0;
    titleEn = titleUr = storyEn = storyUr = '';
    craftMargin = 0.30;
    market = 1.0;
    marketNoteEn = marketNoteUr = _marketFor = '';
    materials = 0;
    days = 1;
    userPrice = 0;
    notifyListeners();
  }
}

final ListingDraft listingDraft = ListingDraft();
