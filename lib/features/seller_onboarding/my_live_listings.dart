import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/lang.dart';
import '../../core/listing_repository.dart';
import '../../data/mock_data.dart' show rs;
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/app_card.dart';
import '../buyer/live_listings_section.dart';

/// Only the signed-in seller's own products, live from Firestore. OWNER: Basit.
Stream<List<LiveListing>> myListingsStream() {
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    return listingRepository.watchAll(limit: 40).map(
      (all) => [
        for (final l in all)
          if (l.sellerId == uid) l,
      ],
    );
  } catch (_) {
    return Stream.value(const <LiveListing>[]); // Firebase not initialised
  }
}

/// The seller's own published products. Shows nothing until she has published one.
class MyLiveListings extends StatelessWidget {
  const MyLiveListings({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LiveListing>>(
      stream: myListingsStream(),
      builder: (context, snap) {
        final mine = snap.data ?? const <LiveListing>[];
        if (mine.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr('My products', 'میری پروڈکٹس'),
                style: AppText.dm(15, weight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              for (final l in mine) ...[
                AppCard(
                  padding: const EdgeInsets.all(10),
                  onTap: () => context.push('/listing/${l.id}'),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 52,
                        height: 52,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LiveListingImage(imageB64: l.imageB64),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr(l.titleEn, l.titleUr).isEmpty ? l.titleEn : tr(l.titleEn, l.titleUr),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.dm(14, weight: FontWeight.w700),
                            ),
                            Text(
                              rs(l.price),
                              style: AppText.price(13, weight: FontWeight.w400, color: AppColors.muted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      AppBadge.live(label: tr('Live', 'لائیو')),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        );
      },
    );
  }
}
