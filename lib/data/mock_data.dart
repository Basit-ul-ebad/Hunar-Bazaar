import '../theme/app_colors.dart';
import '../widgets/product_art.dart';
import '../l10n/l10n.dart';

/// Sample data from DESIGN.md section 4. Text comes from the ARB files via
/// [MockText]; swap this for repositories later.
class Product {
  const Product({
    required this.id,
    required this.price,
    required this.makerId,
    required this.art,
  });
  final String id;
  final int price;
  final String makerId;
  final ArtSpec art;
}

class Craft {
  const Craft(this.id, this.art);
  final String id;
  final ArtSpec art;
}

const rukhsanaId = 'rukhsana';
const zainabId = 'zainab';

const _phulkari = ArtSpec(ArtVariant.phulkari);
const _ajrak = ArtSpec(ArtVariant.ajrak);

const dupatta = Product(
  id: 'phulkari-dupatta',
  price: 5000,
  makerId: rukhsanaId,
  art: _phulkari,
);
const ajrakShawl = Product(
  id: 'ajrak-shawl',
  price: 3200,
  makerId: zainabId,
  art: _ajrak,
);

const newFromMakers = [dupatta, ajrakShawl];

/// Storefront products (B3). Each one has its own art colours.
const storefrontProducts = [
  Product(
    id: 'phulkari-dupatta',
    price: 5000,
    makerId: rukhsanaId,
    art: ArtSpec(
      ArtVariant.phulkari,
      ground: AppColors.madder,
      motif: AppColors.artGold,
    ),
  ),
  Product(
    id: 'bagh-cushion',
    price: 1800,
    makerId: rukhsanaId,
    art: ArtSpec(
      ArtVariant.phulkari,
      ground: AppColors.artUnbleached,
      motif: AppColors.madder,
      center: AppColors.artGold,
    ),
  ),
  Product(
    id: 'phulkari-shawl',
    price: 7500,
    makerId: rukhsanaId,
    art: ArtSpec(
      ArtVariant.phulkari,
      ground: AppColors.artGold,
      motif: AppColors.madder,
      center: AppColors.artUnbleached,
    ),
  ),
  Product(
    id: 'embroidered-potli',
    price: 900,
    makerId: rukhsanaId,
    art: ArtSpec(
      ArtVariant.phulkari,
      ground: AppColors.indigo,
      motif: AppColors.artGold,
      center: AppColors.artUnbleached,
    ),
  ),
];

const crafts = [
  Craft('phulkari', ArtSpec(ArtVariant.phulkari)),
  Craft('ajrak', ArtSpec(ArtVariant.ajrak)),
  Craft('ralli', ArtSpec(ArtVariant.ralli)),
  Craft('bluePottery', ArtSpec(ArtVariant.bluePottery)),
];

/// Chips on the shop-setup screen (S2).
const setupCrafts = [
  Craft('phulkari', ArtSpec(ArtVariant.phulkari)),
  Craft('ajrak', ArtSpec(ArtVariant.ajrak)),
  Craft('ralli', ArtSpec(ArtVariant.ralli)),
  Craft('sindhi', ArtSpec(ArtVariant.sindhi)),
  Craft('bluePottery', ArtSpec(ArtVariant.bluePottery)),
];

/// A buyer message on the seller dashboard.
class BuyerMessage {
  const BuyerMessage(this.id);
  final String id; // 'ayesha' | 'sana'
}

const buyerMessages = [BuyerMessage('ayesha'), BuyerMessage('sana')];

/// An order on the orders screen (O1).
class Order {
  const Order({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.when,
    required this.price,
    required this.art,
  });
  final String id;
  final String productId;
  final String buyerId; // 'ayesha' | 'mehreen'
  final String when; // 'today' | 'yesterday'
  final int price;
  final ArtSpec art;
}

const orders = [
  Order(
    id: 'o1',
    productId: 'phulkari-dupatta',
    buyerId: 'ayesha',
    when: 'today',
    price: 5000,
    art: ArtSpec(ArtVariant.phulkari),
  ),
  Order(
    id: 'o2',
    productId: 'bagh-cushion',
    buyerId: 'mehreen',
    when: 'yesterday',
    price: 1800,
    art: ArtSpec(
      ArtVariant.phulkari,
      ground: AppColors.artUnbleached,
      motif: AppColors.madder,
    ),
  ),
];

/// "5000" -> "Rs 5,000".
String rs(int amount) {
  final s = amount.abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(',');
    b.write(s[i]);
  }
  return 'Rs ${amount < 0 ? '-' : ''}$b';
}

/// Looks up the translated text for sample data ids.
class MockText {
  const MockText(this.l);
  final AppLocalizations l;

  String productShort(String id) => switch (id) {
    'ajrak-shawl' => l.productAjrakShawl,
    'bagh-cushion' => l.productCushion,
    'phulkari-shawl' => l.productShawl,
    'embroidered-potli' => l.productPotli,
    'phulkari-dupatta' => l.productDupattaShort,
    _ => l.productDupatta,
  };

  /// Storefront names ("Phulkari dupatta") are shorter than the home-page ones.
  String productStore(String id) =>
      id == 'phulkari-dupatta' ? l.productDupatta : productShort(id);

  String makerFirst(String id) =>
      id == zainabId ? l.makerZainab : l.makerRukhsana;
  String makerFull(String id) =>
      id == zainabId ? l.makerZainab : l.makerRukhsanaBibi;
  String makerCity(String id) => id == zainabId ? l.cityHala : l.cityMultan;
  String makerCityFull(String id) =>
      id == zainabId ? l.cityHala : l.cityMultanPunjab;
  String shop(String id) => l.shopRukhsana;
  String byline(String makerId) =>
      l.byMaker(makerFirst(makerId), makerCity(makerId));

  String buyer(String id) => switch (id) {
    'sana' => l.buyerSana,
    'mehreen' => l.buyerMehreen,
    _ => l.buyerAyesha,
  };
  String buyerCity(String id) => switch (id) {
    'sana' => l.cityKarachi,
    'mehreen' => l.cityIslamabad,
    _ => l.cityLahore,
  };
  String buyerMessage(String id) => id == 'sana' ? l.msgSana : l.msgAyesha;
  String when(String w) => w == 'yesterday' ? l.whenYesterday : l.whenToday;

  String craft(String id) => switch (id) {
    'ajrak' => l.craftAjrak,
    'ralli' => l.craftRalli,
    'bluePottery' => l.craftBluePottery,
    'sindhi' => l.craftSindhi,
    _ => l.craftPhulkari,
  };
}
