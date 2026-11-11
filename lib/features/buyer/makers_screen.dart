import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/lang.dart';
import '../../core/listing_repository.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/ajrak_border.dart';
import '../../widgets/app_card.dart';
import '../../widgets/maker_avatar.dart';

/// All makers on the marketplace, built from the live listings. OWNER: Basit.
class MakersScreen extends StatelessWidget {
  const MakersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Stream<List<LiveListing>> stream;
    try {
      stream = listingRepository.watchAll(limit: 100);
    } catch (_) {
      stream = Stream.value(const <LiveListing>[]);
    }
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.ink),
                      onPressed: () => context.canPop() ? context.pop() : context.go('/'),
                    ),
                    Text(tr('Makers', 'کاریگر'), style: AppText.fraunces(20)),
                  ],
                ),
              ),
            ),
          ),
          const AjrakBorder(),
          Expanded(
            child: StreamBuilder<List<LiveListing>>(
              stream: stream,
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final byMaker = <String, List<LiveListing>>{};
                for (final l in snap.data!) {
                  byMaker.putIfAbsent(l.sellerId, () => []).add(l);
                }
                if (byMaker.isEmpty) {
                  return Center(
                    child: Text(tr('No makers yet.', 'ابھی کوئی کاریگر نہیں۔'), style: AppText.dm(15, color: AppColors.muted)),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    for (final e in byMaker.entries) ...[
                      AppCard(
                        padding: const EdgeInsets.all(12),
                        onTap: () => context.go('/maker/${e.key}'),
                        child: Row(
                          children: [
                            MakerAvatar.initial(
                              e.value.first.sellerName.isEmpty ? '?' : e.value.first.sellerName.characters.first,
                              size: 44,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.value.first.sellerName.isEmpty ? tr('Maker', 'کاریگر') : e.value.first.sellerName,
                                    style: AppText.dm(15, weight: FontWeight.w700),
                                  ),
                                  Text(
                                    '${e.value.first.city} · ${e.value.length} ${tr('products', 'پروڈکٹس')}',
                                    style: AppText.dm(13, color: AppColors.muted),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.muted),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
