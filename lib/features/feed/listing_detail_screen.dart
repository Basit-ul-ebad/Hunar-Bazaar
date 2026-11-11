import 'package:flutter/material.dart';
import '../../core/lang.dart';
import '../../core/models.dart';
import '../../core/pricing.dart';
import '../../theme/app_colors.dart';
import '../../widgets/fair_price_badge.dart';
import '../../widgets/listing_image.dart';

/// Product detail + "why this price" + contact seller. OWNER: UI partner.
/// TODO(partner): make this beautiful - price breakdown card, features, seller info.
/// TODO(Basit): WhatsApp button needs url_launcher (wa.me/<sellerWhatsapp>).
class ListingDetailScreen extends StatelessWidget {
  final Listing listing;
  const ListingDetailScreen({super.key, required this.listing});

  @override
  Widget build(BuildContext context) {
    final l = listing;
    return Scaffold(
      appBar: AppBar(title: Text(tr(l.titleEn, l.titleUr), maxLines: 1)),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 4 / 3,
            child: ListingImage(imageB64: l.imageB64, category: l.category),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tr(l.titleEn, l.titleUr),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('${l.sellerName} - ${l.city}',
                    style: const TextStyle(color: AppColors.inkSoft)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(pkr(l.priceRec),
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    const SizedBox(width: 10),
                    const FairPriceBadge(),
                  ],
                ),
                Text('${pkr(l.priceLow)} - ${pkr(l.priceHigh)}',
                    style: const TextStyle(color: AppColors.inkSoft)),
                const SizedBox(height: 16),
                Text(tr(l.descEn, l.descUr)),
                const SizedBox(height: 16),
                Text(tr('Why this price', 'یہ قیمت کیوں'),
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 6),
                Text(tr(l.reasonEn, l.reasonUr)),
                const SizedBox(height: 4),
                Text(
                  tr('AI estimate, not a guarantee.', 'یہ اے آئی کا اندازہ ہے، ضمانت نہیں۔'),
                  style: const TextStyle(fontSize: 12, color: AppColors.inkSoft),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('WhatsApp link coming soon')),
                  ),
                  icon: const Icon(Icons.chat),
                  label: Text(tr('Contact seller on WhatsApp', 'واٹس ایپ پر رابطہ کریں')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
