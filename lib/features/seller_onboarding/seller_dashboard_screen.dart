import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/lang.dart';
import '../../core/listing_repository.dart';
import '../../core/seller_profile.dart';
import '../../data/mock_data.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/ajrak_border.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/app_card.dart';
import '../../widgets/maker_avatar.dart';
import '../../widgets/mixed_text.dart';
import '../../widgets/product_art.dart';
import '../../widgets/seller_bottom_nav.dart';
import '../../widgets/tappable.dart';
import '../../widgets/text_link.dart';
import 'my_live_listings.dart';

/// S3 · Seller dashboard (`/seller`). In Urdu it is U1: RTL, Nastaliq, DM Sans numbers.
class SellerDashboardScreen extends StatelessWidget {
  const SellerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final urdu = Localizations.localeOf(context).languageCode == 'ur';
    return Scaffold(
      bottomNavigationBar: SellerBottomNav(
        current: 0,
        onSelected: (i) => SellerNav.go(context, i),
      ),
      body: Column(
        children: [
          const _Header(),
          const AjrakBorder(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: _Body(urdu: urdu),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              const MakerAvatar(size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('Assalam-o-alaikum', 'السلام علیکم'),
                      style: AppText.dm(13, color: AppColors.muted),
                    ),
                    Text(
                      sellerProfile.shopName.isEmpty
                          ? tr('My shop', 'میری دکان')
                          : sellerProfile.shopName,
                      style: AppText.fraunces(18),
                    ),
                  ],
                ),
              ),
              TextLink(
                l.viewShop,
                size: 13,
                onTap: () => context.go('/'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.urdu});
  final bool urdu;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return StreamBuilder<List<LiveListing>>(
      stream: myListingsStream(),
      builder: (context, snap) {
        final stats = [
          (tr('Products', 'پروڈکٹس'), '${snap.data?.length ?? 0}'),
          (l.ordersLabel, '0'),
          (l.thisMonth, rs(0)),
        ];
        return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < stats.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(
                child: AppCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stats[i].$1,
                        style: AppText.dm(12, color: AppColors.muted),
                      ),
                      const SizedBox(height: 2),
                      // Same height for every value, even when one is scaled down.
                      SizedBox(
                        height: MediaQuery.textScalerOf(context).scale(24),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(stats[i].$2, style: AppText.price(18)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        const _AddProduct(),
        const SizedBox(height: 16),
        const MyLiveListings(),
      ],
    );
      },
    );
  }
}

class _AddProduct extends StatelessWidget {
  const _AddProduct();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Material(
      color: AppColors.madderTint,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/seller/new/photos'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.madder,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, size: 24, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.addNewProduct,
                      style: AppText.dm(16, weight: FontWeight.w700),
                    ),
                    MixedText(
                      l.onePhoto,
                      style: AppText.dm(13, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
