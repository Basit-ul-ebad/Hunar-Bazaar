/// The current seller's shop details (filled in at shop setup). OWNER: Basit.
class SellerProfile {
  String shopName = '';
  String city = 'Multan';
}

final SellerProfile sellerProfile = SellerProfile();

/// "Multan, Punjab" -> "Multan" (handles the Urdu comma too).
String cityKey(String raw) {
  final k = raw.split(RegExp(r'[,،]')).first.trim();
  return k.isEmpty ? 'Multan' : k;
}
