import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/maker_avatar.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/product_art.dart';
import '../../widgets/step_header.dart';

/// B2 · Product page (`/product/:id`). Only the sample dupatta has full detail copy.
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.productId});

  final String productId;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = MockText(l);
    final p = dupatta;
    final maker = p.makerId;
    final top = MediaQuery.paddingOf(context).top;
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: _OrderBar(price: rs(p.price)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 330,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ProductArt(
                    variant: ArtVariant.phulkari,
                    tile: 30,
                    motifRatio: 0.367,
                    centerMark: CenterMark.square,
                    ring: true,
                    bandColor: AppColors.ink.withValues(alpha: 0.06),
                    bandHeight: 80,
                    semanticLabel:
                        'Product photo placeholder: phulkari dupatta',
                  ),
                  Positioned(
                    left: 16,
                    top: top + 16,
                    child: CircleIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      label: l.back,
                      bordered: false,
                      onTap: () =>
                          context.canPop() ? context.pop() : context.go('/'),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    top: top + 16,
                    child: CircleIconButton(
                      icon: _saved ? Icons.favorite : Icons.favorite_border,
                      label: _saved ? l.removeSaved : l.save,
                      bordered: false,
                      onTap: () => setState(() => _saved = !_saved),
                    ),
                  ),
                  Positioned(
                    right: 16,
                    bottom: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '1 / 4',
                        style: AppText.dm(12, weight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.productDupattaFull,
                    style: AppText.fraunces(22, height: 1.25),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    spacing: 10,
                    children: [
                      Text(rs(p.price), style: AppText.price(24)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Icon(
                                  Icons.star_rounded,
                                  size: 14,
                                  color: AppColors.muted,
                                ),
                              ),
                              TextSpan(text: ' ${l.ratingReviews}'),
                            ],
                          ),
                          style: AppText.dm(13, color: AppColors.muted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _InfoChip(l.chipHandEmbroidered),
                      _InfoChip(l.hoursOfWork('18')),
                      _InfoChip(l.cashOnDelivery),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Material(
                    color: AppColors.bg,
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => context.go('/maker/$maker'),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const MakerAvatar(size: 48),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l.madeBy,
                                    style: AppText.dm(
                                      12,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${t.makerFull(maker)} · ${t.makerCity(maker)}',
                                    style: AppText.dm(
                                      15,
                                      weight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 1),
                                        child: Icon(
                                          Icons.verified,
                                          size: 14,
                                          color: AppColors.indigo,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          l.verifiedYears,
                                          style: AppText.dm(
                                            12,
                                            weight: FontWeight.w700,
                                            color: AppColors.indigo,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: AppColors.muted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.theStory,
                    style: AppText.dm(15, weight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(l.storyText, style: AppText.dm(14, height: 1.55)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(label, style: AppText.dm(13, weight: FontWeight.w500)),
  );
}

class _OrderBar extends StatelessWidget {
  const _OrderBar({required this.price});
  final String price;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final inset = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, inset > 20 ? inset : 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(price, style: AppText.price(18)),
              Text(l.deliveryIn, style: AppText.dm(12, color: AppColors.muted)),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: PrimaryButton(
              label: l.orderOnWhatsApp,
              icon: Icons.chat_bubble_outline,
              height: 52,
              fontSize: 16,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
