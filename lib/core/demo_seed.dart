import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../features/listing/pricing_calc.dart';
import 'cities.dart';

/// Puts a few demo products into Firestore the first time the app runs against an EMPTY
/// `listings` collection, so the marketplace is not blank. OWNER: Basit.
/// They are marked `demo: true` and have no WhatsApp number.
class _Demo {
  const _Demo(this.image, this.seller, this.city, this.titleEn, this.titleUr,
      this.storyEn, this.storyUr, this.materials, this.hours, this.margin);
  final String image;
  final String seller;
  final String city;
  final String titleEn;
  final String titleUr;
  final String storyEn;
  final String storyUr;
  final int materials;
  final int hours;
  final double margin;
}

const _demos = <_Demo>[
  _Demo(
    '1_phulkari_dupatta', "Rukhsana's Phulkari", 'Multan',
    'Phulkari dupatta, hand-embroidered',
    'ہاتھ سے کڑھائی والا پھلکاری دوپٹہ',
    'Soft cotton embroidered by hand with bright thread in the traditional Punjabi star pattern. Each star is stitched one by one.',
    'نرم سوتی کپڑا، روایتی پنجابی ستاروں کی کڑھائی ہاتھ سے۔ ہر ستارہ ایک ایک کر کے کاڑھا جاتا ہے۔',
    1200, 18, 0.30,
  ),
  _Demo(
    '2_ajrak_shawl', "Zainab's Ajrak", 'Hyderabad',
    'Ajrak-style shawl in indigo and red',
    'نیلے اور سرخ رنگ کی اجرک طرز شال',
    'A warm shawl in the classic Sindhi indigo and madder colours with a repeating diamond print.',
    'گرم شال، سندھ کے روایتی نیلے اور سرخ رنگ اور ہیروں کے ڈیزائن کے ساتھ۔',
    1500, 12, 0.30,
  ),
  _Demo(
    '3_crochet_table_runner', "Farah's Crochet", 'Peshawar',
    'Crochet table runner with scalloped edge',
    'کروشیا ٹیبل رنر، لہردار کناروں کے ساتھ',
    'Cream hand-crocheted table runner with lace rosettes and a scalloped border.',
    'کریم رنگ کا ہاتھ سے بنا ٹیبل رنر، لیس کے پھولوں اور لہردار کناروں کے ساتھ۔',
    300, 8, 0.20,
  ),
  _Demo(
    '4_beaded_jewellery_set', "Hina's Beadwork", 'Islamabad',
    'Beaded necklace and earring set',
    'موتیوں کا ہار اور بالیوں کا سیٹ',
    'Hand-beaded necklace with matching earrings in gold, coral and pearl tones. Light enough for daily wear.',
    'سنہری، مرجانی اور موتی رنگوں کا ہاتھ سے بنا ہار اور بالیاں۔ روزانہ پہننے کے لیے ہلکا۔',
    450, 5, 0.25,
  ),
  _Demo(
    '5_ralli_quilt', "Sakina's Ralli", 'Karachi',
    'Sindhi ralli patchwork quilt',
    'سندھی رلی پیچ ورک',
    'A bright patchwork ralli stitched entirely by hand from colourful fabric squares.',
    'رنگین کپڑوں کے ٹکڑوں سے مکمل ہاتھ سے سلی ہوئی چمکدار رلی۔',
    1800, 30, 0.35,
  ),
  _Demo(
    '6_embroidered_cushion', "Nasreen's Embroidery", 'Lahore',
    'Embroidered floral cushion cover',
    'پھولوں کی کڑھائی والا کشن کور',
    'Teal cushion cover with a hand-embroidered flower motif and a golden border.',
    'فیروزی کشن کور، ہاتھ سے کڑھائی کیے ہوئے پھول اور سنہری کنارے کے ساتھ۔',
    600, 9, 0.25,
  ),
];

Future<void> seedDemoListingsIfEmpty() async {
  final col = FirebaseFirestore.instance.collection('listings');
  final existing = await col.limit(1).get();
  if (existing.docs.isNotEmpty) return;

  final now = DateTime.now();
  for (var i = 0; i < _demos.length; i++) {
    final d = _demos[i];
    final bytes = await rootBundle.load('assets/seed/${d.image}.jpg');
    final market = fallbackMultiplier(d.city);
    final s = suggestPrice(
      materials: d.materials,
      hours: d.hours,
      margin: d.margin,
      market: market,
    );
    await col.add({
      'sellerId': 'demo_${i + 1}',
      'sellerName': d.seller,
      'sellerWhatsapp': '',
      'city': d.city,
      'titleEn': d.titleEn,
      'titleUr': d.titleUr,
      'storyEn': d.storyEn,
      'storyUr': d.storyUr,
      'price': s.fair,
      'priceFair': s.fair,
      'priceLow': s.low,
      'priceHigh': s.high,
      'materials': d.materials,
      'hours': d.hours,
      'margin': s.margin,
      'market': s.market,
      'marketNoteEn': 'Adjusted for the ${d.city} market.',
      'marketNoteUr': 'قیمت ${d.city} کی مارکیٹ کے مطابق ایڈجسٹ کی گئی۔',
      'imageB64': base64Encode(bytes.buffer.asUint8List()),
      'status': 'active',
      'demo': true,
      'createdAt': Timestamp.fromDate(now.subtract(Duration(hours: i + 1))),
    });
  }
  debugPrint('[HB] Seeded ${_demos.length} demo listings into Firestore');
}
