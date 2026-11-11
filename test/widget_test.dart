import 'package:flutter_test/flutter_test.dart';
import 'package:hunar_bazaar/features/listing/pricing_calc.dart';

void main() {
  test('fair price = (materials + hours x rate) x (1 + margin)', () {
    final s = suggestPrice(materials: 1000, hours: 10, margin: 0.30);
    expect(s.timeValue, 1500);
    expect(s.fair, 3300);
    expect(s.low < s.fair && s.fair < s.high, isTrue);
  });

  test('local market multiplier scales the price', () {
    final base = suggestPrice(materials: 1000, hours: 10, margin: 0.30);
    final hot = suggestPrice(materials: 1000, hours: 10, margin: 0.30, market: 1.2);
    expect(hot.fair, 3900);
    expect(hot.fair > base.fair, isTrue);
  });

  test('AI-supplied margin and market are clamped', () {
    final s = suggestPrice(materials: 1000, hours: 10, margin: 0.9);
    expect(s.margin, 0.40);
    expect(s.fair, 3500);
    final m = suggestPrice(materials: 1000, hours: 10, margin: 0.30, market: 5);
    expect(m.market, 1.25);
  });
}
