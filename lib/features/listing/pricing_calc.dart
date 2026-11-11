/// Fair-price formula from DESIGN.md (calculated in code, never by the AI):
///   fair = (materials + hours × hourlyRate) × (1 + craftMargin)
///   low = 0.88 × fair, high = 1.08 × fair, each rounded to the nearest Rs 100.
class PriceSuggestion {
  const PriceSuggestion({
    required this.fair,
    required this.low,
    required this.high,
    required this.timeValue,
    required this.margin,
  });

  final int fair;
  final int low;
  final int high;

  /// hours × hourly rate (Rs).
  final int timeValue;

  /// Craft margin, clamped to 15–40 %.
  final double margin;
}

const kHourlyRate = 150; // editable in settings later
const kHoursPerDay = 6;

int roundTo100(num v) => (v / 100).round() * 100;

PriceSuggestion suggestPrice({
  required int materials,
  required int hours,
  required double margin,
  int hourlyRate = kHourlyRate,
}) {
  final m = margin.clamp(0.15, 0.40).toDouble();
  final timeValue = hours * hourlyRate;
  final fair = (materials + timeValue) * (1 + m);
  return PriceSuggestion(
    fair: roundTo100(fair),
    low: roundTo100(fair * 0.88),
    high: roundTo100(fair * 1.08),
    timeValue: timeValue,
    margin: m,
  );
}

/// Where the thumb sits on the track: the low–high band fills 10 %–90 %.
double thumbPosition(int price, PriceSuggestion s) {
  if (s.high <= s.low) return 0.5;
  final t = (price - s.low) / (s.high - s.low);
  return (0.1 + 0.8 * t).clamp(0.0, 1.0);
}
