// Shared data models. OWNER: Basit (backend). UI people: build against these, don't edit.

const List<String> kCategories = [
  'Embroidery',
  'Stitching',
  'Handicrafts',
  'Food',
  'Jewellery',
  'Home Decor',
];

/// Output of the pricing engine (see pricing.dart). All values are PKR.
class PriceResult {
  final double low;
  final double rec;
  final double high;
  final double multiplier;
  final double base;

  const PriceResult({
    required this.low,
    required this.rec,
    required this.high,
    required this.multiplier,
    required this.base,
  });
}

/// One product for sale. Mirrors the Firestore document `listings/{id}`.
class Listing {
  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerWhatsapp; // international format, no "+": 923001234567
  final String city;
  final String category;
  final String? imageB64; // base64 JPEG, null => UI shows a placeholder
  final String titleEn;
  final String titleUr;
  final String descEn;
  final String descUr;
  final List<String> features;
  final List<String> tags;
  final double materialsCost;
  final double hours;
  final double hourlyRate;
  final double priceLow;
  final double priceRec;
  final double priceHigh;
  final double marketMultiplier;
  final String reasonEn;
  final String reasonUr;
  final String comparablesNote;
  final DateTime createdAt;
  final String status; // "active"

  const Listing({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerWhatsapp,
    required this.city,
    required this.category,
    this.imageB64,
    required this.titleEn,
    required this.titleUr,
    required this.descEn,
    required this.descUr,
    required this.features,
    required this.tags,
    required this.materialsCost,
    required this.hours,
    required this.hourlyRate,
    required this.priceLow,
    required this.priceRec,
    required this.priceHigh,
    required this.marketMultiplier,
    required this.reasonEn,
    required this.reasonUr,
    this.comparablesNote = '',
    required this.createdAt,
    this.status = 'active',
  });

  Map<String, dynamic> toMap() => {
        'sellerId': sellerId,
        'sellerName': sellerName,
        'sellerWhatsapp': sellerWhatsapp,
        'city': city,
        'category': category,
        'imageB64': imageB64,
        'titleEn': titleEn,
        'titleUr': titleUr,
        'descEn': descEn,
        'descUr': descUr,
        'features': features,
        'tags': tags,
        'materialsCost': materialsCost,
        'hours': hours,
        'hourlyRate': hourlyRate,
        'priceLow': priceLow,
        'priceRec': priceRec,
        'priceHigh': priceHigh,
        'marketMultiplier': marketMultiplier,
        'reasonEn': reasonEn,
        'reasonUr': reasonUr,
        'comparablesNote': comparablesNote,
        'createdAt': createdAt, // Firestore SDK converts DateTime -> Timestamp
        'status': status,
      };

  factory Listing.fromMap(String id, Map<String, dynamic> m) {
    double d(dynamic v) => (v as num?)?.toDouble() ?? 0;
    List<String> l(dynamic v) =>
        (v as List?)?.map((e) => e.toString()).toList() ?? <String>[];
    DateTime when(dynamic v) {
      if (v is DateTime) return v;
      try {
        return (v as dynamic).toDate() as DateTime; // Firestore Timestamp
      } catch (_) {
        return DateTime.now();
      }
    }

    return Listing(
      id: id,
      sellerId: (m['sellerId'] ?? '') as String,
      sellerName: (m['sellerName'] ?? '') as String,
      sellerWhatsapp: (m['sellerWhatsapp'] ?? '') as String,
      city: (m['city'] ?? '') as String,
      category: (m['category'] ?? '') as String,
      imageB64: m['imageB64'] as String?,
      titleEn: (m['titleEn'] ?? '') as String,
      titleUr: (m['titleUr'] ?? '') as String,
      descEn: (m['descEn'] ?? '') as String,
      descUr: (m['descUr'] ?? '') as String,
      features: l(m['features']),
      tags: l(m['tags']),
      materialsCost: d(m['materialsCost']),
      hours: d(m['hours']),
      hourlyRate: d(m['hourlyRate']),
      priceLow: d(m['priceLow']),
      priceRec: d(m['priceRec']),
      priceHigh: d(m['priceHigh']),
      marketMultiplier: d(m['marketMultiplier']),
      reasonEn: (m['reasonEn'] ?? '') as String,
      reasonUr: (m['reasonUr'] ?? '') as String,
      comparablesNote: (m['comparablesNote'] ?? '') as String,
      createdAt: when(m['createdAt']),
      status: (m['status'] ?? 'active') as String,
    );
  }
}
