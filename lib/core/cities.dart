/// Seeded city data - fallback when Google Search grounding returns nothing. OWNER: Basit.
class CityTier {
  final String name;
  final int costTier; // 1 (cheap) - 3 (expensive)
  final int demandTier; // 1 (low) - 3 (high)
  final double defaultMultiplier;
  const CityTier(this.name, this.costTier, this.demandTier, this.defaultMultiplier);
}

const List<CityTier> kCities = [
  CityTier('Islamabad', 3, 3, 1.25),
  CityTier('Lahore', 3, 3, 1.20),
  CityTier('Karachi', 3, 3, 1.20),
  CityTier('Faisalabad', 2, 2, 1.00),
  CityTier('Multan', 2, 2, 1.00),
  CityTier('Peshawar', 2, 2, 1.00),
  CityTier('Hyderabad', 2, 2, 0.95),
  CityTier('Quetta', 2, 1, 0.95),
];

List<String> get kCityNames => kCities.map((c) => c.name).toList();

double fallbackMultiplier(String city) => kCities
    .firstWhere((c) => c.name == city, orElse: () => const CityTier('', 2, 2, 1.0))
    .defaultMultiplier;
