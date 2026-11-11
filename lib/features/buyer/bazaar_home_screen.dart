import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../l10n/l10n.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/ajrak_border.dart';
import '../../widgets/buyer_bottom_nav.dart';
import '../../widgets/product_art.dart';
import '../../widgets/product_card.dart';
import '../../widgets/step_header.dart';
import '../../widgets/text_link.dart';
import '../../widgets/two_column_grid.dart';
import 'live_listings_section.dart';

/// B1 · Bazaar home (`/`).
class BazaarHomeScreen extends StatelessWidget {
  const BazaarHomeScreen({super.key});

  void _onNav(BuildContext context, int i) {
    switch (i) {
      case 1:
        context.go('/maker/me');
      case 3:
        context.go('/sell');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = MockText(l);
    return Scaffold(
      bottomNavigationBar: BuyerBottomNav(
        current: 0,
        onSelected: (i) => _onNav(context, i),
      ),
      body: Column(
        children: [
          _Header(),
          const AjrakBorder(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeroCard(),
                  const SizedBox(height: 18),
                  Text(
                    l.shopByCraft,
                    style: AppText.dm(16, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final c in crafts)
                        Expanded(child: _CraftItem(craft: c)),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const LiveListingsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hunar Bazaar', style: AppText.wordmark(22)),
                        Text(
                          l.handmadeInPakistan,
                          style: AppText.dm(
                            12,
                            color: AppColors.muted,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleIconButton(
                    icon: Icons.favorite_border,
                    label: l.saved,
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: TextField(
                  textInputAction: TextInputAction.search,
                  style: AppText.dm(15),
                  decoration: InputDecoration(
                    hintText: l.searchHint,
                    hintStyle: AppText.dm(15, color: AppColors.muted),
                    filled: true,
                    fillColor: AppColors.field,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.only(left: 16, right: 10),
                      child: Icon(
                        Icons.search,
                        size: 18,
                        color: AppColors.muted,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: AppColors.inputBorder,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.madderTint,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.heroTitle, style: AppText.fraunces(20, height: 1.25)),
                const SizedBox(height: 4),
                TextLink(
                  l.meetMakers,
                  color: AppColors.madder,
                  onTap: () => context.go('/maker/me'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 96,
            height: 96,
            child: ProductArt(
              variant: ArtVariant.phulkari,
              tile: 16,
              motifRatio: 0.375,
              bandColor: AppColors.artGold.withValues(alpha: 0.18),
              bandHeight: 34,
              radius: BorderRadius.circular(10),
              semanticLabel: 'Folded phulkari fabric',
            ),
          ),
        ],
      ),
    );
  }
}

class _CraftItem extends StatelessWidget {
  const _CraftItem({required this.craft});
  final Craft craft;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = MockText(l);
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: SizedBox(
              width: 64,
              height: 64,
              child: ProductArt.spec(
                craft.art,
                tile: 16,
                centerMark: CenterMark.none,
                squareRatio: 0.625,
                dotRatio: 0.125,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            t.craft(craft.id),
            textAlign: TextAlign.center,
            style: AppText.dm(13, weight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
