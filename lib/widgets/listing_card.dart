import 'package:flutter/material.dart';
import '../core/lang.dart';
import '../core/models.dart';
import '../core/pricing.dart';
import '../theme/app_colors.dart';
import 'fair_price_badge.dart';
import 'listing_image.dart';

/// One product tile for the buyer feed / seller shop. OWNER: UI partner.
class ListingCard extends StatelessWidget {
  final Listing listing;
  final VoidCallback? onTap;
  const ListingCard({super.key, required this.listing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: ListingImage(
                imageB64: listing.imageB64,
                category: listing.category,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(listing.titleEn, listing.titleUr),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place, size: 14, color: AppColors.inkSoft),
                      const SizedBox(width: 2),
                      Text(
                        listing.city,
                        style: const TextStyle(color: AppColors.inkSoft, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pkr(listing.priceRec),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const FairPriceBadge(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
