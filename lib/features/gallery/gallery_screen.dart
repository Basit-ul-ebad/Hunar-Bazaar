import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/ajrak_border.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/app_card.dart';
import '../../widgets/buyer_bottom_nav.dart';
import '../../widgets/choice_chip.dart';
import '../../widgets/field_card.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/maker_avatar.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/product_art.dart';
import '../../widgets/product_card.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/seller_bottom_nav.dart';
import '../../widgets/step_header.dart';
import '../../widgets/step_progress.dart';

/// Debug route `/gallery`: every shared widget in one scroll.
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  bool _chip = true;
  double _progress = 0.6;
  int _buyerNav = 0;
  int _sellerNav = 0;

  Widget _section(String title, Widget child) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppText.dm(
            13,
            weight: FontWeight.w700,
            color: AppColors.muted,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget gallery', style: AppText.fraunces(20)),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _section('AjrakBorder', const AjrakBorder()),
          _section(
            'AjrakBorder(progress) — drag',
            Column(
              children: [
                AjrakBorder(progress: _progress),
                Slider(
                  value: _progress,
                  activeColor: AppColors.madder,
                  onChanged: (v) => setState(() => _progress = v),
                ),
              ],
            ),
          ),
          _section(
            'ProductArt: phulkari · ajrak · ralli · bluePottery · sindhi',
            SizedBox(
              height: 72,
              child: Row(
                children: [
                  for (final v in ArtVariant.values) ...[
                    Expanded(
                      child: ProductArt(
                        variant: v,
                        tile: v == ArtVariant.ajrak ? 24 : 16,
                        radius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          ),
          _section(
            'MakerAvatar 36 / 44 / 48 / 76 · initial',
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final s in [36.0, 44.0, 48.0, 76.0]) ...[
                  MakerAvatar(size: s),
                  const SizedBox(width: 10),
                ],
                const MakerAvatar.initial('A'),
              ],
            ),
          ),
          _section(
            'PrimaryButton',
            PrimaryButton(
              label: 'Order on WhatsApp',
              icon: Icons.chat_bubble_outline,
              onPressed: () {},
            ),
          ),
          _section(
            'SecondaryButton',
            SecondaryButton(label: 'Secondary', onPressed: () {}),
          ),
          _section(
            'AppCard',
            const AppCard(child: Text('Card: surface, 1 px line, radius 12')),
          ),
          _section('StepProgress 2 of 4', const StepProgress(step: 2)),
          _section(
            'StepHeader',
            StepHeader(
              title: 'Step 2 of 4 · Details',
              leadingLabel: 'Back',
              onLeading: () {},
              trailing: const Icon(Icons.mic_none, color: AppColors.indigo),
            ),
          ),
          _section(
            'ProductCard',
            SizedBox(
              width: 170,
              child: ProductCard(
                art: const ProductArt(variant: ArtVariant.phulkari),
                title: 'Phulkari dupatta, hand-embroidered',
                price: 'Rs 5,000',
                byline: 'by Rukhsana · Multan',
                onTap: () {},
              ),
            ),
          ),
          _section(
            'AppBadge: live · verified · stamp · ai',
            const Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppBadge.live(),
                AppBadge.verified(),
                AppBadge.stamp(),
                AppBadge.ai(),
              ],
            ),
          ),
          _section(
            'AppChoiceChip (tap)',
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppChoiceChip(
                  label: 'Phulkari',
                  selected: _chip,
                  onTap: () => setState(() => _chip = !_chip),
                  leading: const ProductArt(
                    variant: ArtVariant.phulkari,
                    tile: 30,
                    centerMark: CenterMark.none,
                  ),
                ),
                AppChoiceChip(
                  label: 'Ajrak',
                  selected: !_chip,
                  onTap: () => setState(() => _chip = !_chip),
                ),
                AppChoiceChip(
                  label: '+ Other',
                  selected: false,
                  dashed: true,
                  onTap: () {},
                ),
              ],
            ),
          ),
          _section(
            'LanguageToggle · compact',
            const Row(
              children: [
                LanguageToggle(),
                SizedBox(width: 12),
                LanguageToggle(compact: true),
              ],
            ),
          ),
          _section(
            'FieldCard',
            const FieldCard(
              label: 'Title',
              ai: true,
              child: TextField(
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: 'Phulkari dupatta',
                ),
              ),
            ),
          ),
          _section(
            'BuyerBottomNav',
            BuyerBottomNav(
              current: _buyerNav,
              onSelected: (i) => setState(() => _buyerNav = i),
            ),
          ),
          _section(
            'SellerBottomNav',
            SellerBottomNav(
              current: _sellerNav,
              onSelected: (i) => setState(() => _sellerNav = i),
            ),
          ),
        ],
      ),
    );
  }
}
