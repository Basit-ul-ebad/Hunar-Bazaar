import 'models.dart';

/// Deterministic pricing engine. OWNER: Basit.
/// base = (materials + hours x hourlyRate) x (1 + overhead); AI only adds a clamped multiplier.
const double kHourlyRate = 300; // PKR/hr - assumption, verify vs current minimum wage
const double kOverhead = 0.10;

PriceResult computePrice({
  required double materials,
  required double hours,
  required double aiMultiplier,
  double hourlyRate = kHourlyRate,
}) {
  final base = (materials + hours * hourlyRate) * (1 + kOverhead);
  final m = aiMultiplier.clamp(0.8, 1.5).toDouble(); // AI can never go wild
  final rec = base * m;
  double r(double v) => (v / 50).round() * 50.0; // nearest 50 PKR
  return PriceResult(
    low: r(rec * 0.9),
    rec: r(rec),
    high: r(rec * 1.15),
    multiplier: m,
    base: base,
  );
}

/// Format PKR with thousands separators: 12500 -> "Rs 12,500".
String pkr(double v) =>
    'Rs ${v.round().toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',')}';
