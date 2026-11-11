import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
                      l.greeting,
                      style: AppText.dm(13, color: AppColors.muted),
                    ),
                    Text(l.shopRukhsana, style: AppText.fraunces(18)),
                  ],
                ),
              ),
              TextLink(
                l.viewShop,
                size: 13,
                onTap: () => context.go('/maker/rukhsana'),
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
    final stats = [
      (l.thisMonth, rs(12400)),
      (l.ordersLabel, '5'),
      (l.shopViews, '340'),
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
        const _Buyers(),
        const SizedBox(height: 16),
        const MyLiveListings(),
        // The Urdu design (U1) has no listings section.
        if (!urdu) ...[const SizedBox(height: 16), const _Listings()],
      ],
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

class _Buyers extends StatelessWidget {
  const _Buyers();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                l.buyersWaiting,
                style: AppText.dm(15, weight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 8),
            MixedText(
              l.nNew('2'),
              style: AppText.dm(
                12,
                weight: FontWeight.w700,
                color: AppColors.madder,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < buyerMessages.length; i++) ...[
                if (i > 0) const Divider(height: 1, color: AppColors.lineSoft),
                _MessageRow(m: buyerMessages[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _MessageRow extends StatelessWidget {
  const _MessageRow({required this.m});
  final BuyerMessage m;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = MockText(l);
    final name = t.buyer(m.id);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          MakerAvatar.initial(name.characters.first),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name · ${t.buyerCity(m.id)}',
                  style: AppText.dm(14, weight: FontWeight.w700),
                ),
                Text(
                  t.buyerMessage(m.id),
                  style: AppText.dm(13, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Tappable(
            onTap: () {},
            semanticLabel: l.reply,
            radius: BorderRadius.circular(18),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.ink),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                l.reply,
                style: AppText.dm(13, weight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Listings extends StatelessWidget {
  const _Listings();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                l.yourListings,
                style: AppText.dm(15, weight: FontWeight.w700),
              ),
            ),
            TextLink(
              l.seeAllN('12'),
              size: 13,
              onTap: () => context.go('/maker/rukhsana'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        AppCard(
          padding: const EdgeInsets.all(10),
          onTap: () => context.go('/product/${dupatta.id}'),
          child: Row(
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: ProductArt(
                  variant: ArtVariant.phulkari,
                  tile: 13,
                  motifRatio: 0.385,
                  centerMark: CenterMark.none,
                  radius: BorderRadius.circular(8),
                  semanticLabel: 'Product thumbnail',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.productDupatta,
                      style: AppText.dm(14, weight: FontWeight.w700),
                    ),
                    MixedText(
                      l.priceViews(rs(5000), '86'),
                      style: AppText.dm(13, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AppBadge.live(label: l.live),
            ],
          ),
        ),
      ],
    );
  }
}
