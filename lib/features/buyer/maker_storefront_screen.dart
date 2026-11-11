import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/lang.dart';
import '../../core/listing_repository.dart';
import '../../core/seller_profile.dart';
import '../../data/mock_data.dart' show rs;
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/ajrak_border.dart';
import '../../widgets/maker_avatar.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/product_card.dart';
import '../../widgets/seller_bottom_nav.dart';
import '../../widgets/two_column_grid.dart';
import '../seller_onboarding/my_live_listings.dart';
import 'live_listings_section.dart';

/// A maker's shop (`/maker/:id`). `me` = the signed-in seller; otherwise a seller id.
/// Shows real data from Firestore only. OWNER: Basit.
class MakerStorefrontScreen extends StatelessWidget {
  const MakerStorefrontScreen({super.key, required this.makerId});
  final String makerId;

  bool get _isMe => makerId == 'me';

  Stream<List<LiveListing>> _stream() {
    if (_isMe) return myListingsStream();
    try {
      return listingRepository.watchAll(limit: 60).map(
        (all) => [
          for (final l in all)
            if (l.sellerId == makerId) l,
        ],
      );
    } catch (_) {
      return Stream.value(const <LiveListing>[]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      bottomNavigationBar: _isMe
          ? SellerBottomNav(current: 3, onSelected: (i) => SellerNav.go(context, i))
          : null,
      body: StreamBuilder<List<LiveListing>>(
        stream: _stream(),
        builder: (context, snap) {
          final items = snap.data ?? const <LiveListing>[];
          final name = _isMe
              ? (sellerProfile.shopName.isEmpty ? tr('My shop', 'میری دکان') : sellerProfile.shopName)
              : (items.isNotEmpty ? items.first.sellerName : tr('Maker', 'کاریگر'));
          final city = _isMe
              ? (sellerProfile.city.trim().isEmpty ? '' : cityKey(sellerProfile.city))
              : (items.isNotEmpty ? items.first.city : '');
          return Column(
            children: [
              Container(
                color: AppColors.surface,
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 20, 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
                          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
                        ),
                        const MakerAvatar(size: 56),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name, style: AppText.fraunces(20)),
                              if (city.isNotEmpty)
                                Text(city, style: AppText.dm(13, color: AppColors.muted)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const AjrakBorder(),
              Expanded(
                child: snap.connectionState == ConnectionState.waiting && !snap.hasData
                    ? const Center(child: CircularProgressIndicator())
                    : items.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _isMe
                                        ? tr("You haven't listed anything yet.", 'آپ نے ابھی کچھ نہیں لگایا۔')
                                        : tr('No products yet.', 'ابھی کوئی پروڈکٹ نہیں۔'),
                                    textAlign: TextAlign.center,
                                    style: AppText.dm(15, color: AppColors.muted),
                                  ),
                                  if (_isMe) ...[
                                    const SizedBox(height: 16),
                                    PrimaryButton(
                                      label: tr('Add a product', 'پروڈکٹ شامل کریں'),
                                      onPressed: () => context.go('/seller/new/photos'),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                            child: TwoColumnGrid(
                              children: [
                                for (final l in items)
                                  ProductCard(
                                    art: LiveListingImage(imageB64: l.imageB64),
                                    title: tr(l.titleEn, l.titleUr).isEmpty ? l.titleEn : tr(l.titleEn, l.titleUr),
                                    price: rs(l.price),
                                    compact: true,
                                    onTap: () => context.go('/listing/${l.id}'),
                                  ),
                              ],
                            ),
                          ),
              ),
            ],
          );
        },
      ),
    );
  }
}
