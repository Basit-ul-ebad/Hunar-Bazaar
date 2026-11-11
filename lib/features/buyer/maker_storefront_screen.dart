import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../l10n/l10n.dart';
import '../../widgets/underline_tabs.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/maker_avatar.dart';
import '../../widgets/mixed_text.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/product_art.dart';
import '../../widgets/product_card.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/step_header.dart';
import '../../widgets/two_column_grid.dart';

/// B3 · Maker storefront (`/maker/:id`).
class MakerStorefrontScreen extends StatefulWidget {
  const MakerStorefrontScreen({super.key, required this.makerId});

  final String makerId;

  @override
  State<MakerStorefrontScreen> createState() => _MakerStorefrontScreenState();
}

class _MakerStorefrontScreenState extends State<MakerStorefrontScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = MockText(l);
    const maker = rukhsanaId; // sample data only has one full storefront
    final top = MediaQuery.paddingOf(context).top;
    final coverH = 96 + top;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: coverH,
                      width: double.infinity,
                      child: const CustomPaint(painter: _LatticePainter()),
                    ),
                    _Identity(maker: maker),
                  ],
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
                  left: 20,
                  top: coverH - 38,
                  child: const MakerAvatar(size: 76, ring: true),
                ),
              ],
            ),
            _TabBar(
              tabs: [l.productsTab('12'), l.reviewsTab, l.aboutTab],
              selected: _tab,
              onSelected: (i) => setState(() => _tab = i),
            ),
            if (_tab == 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
                child: TwoColumnGrid(
                  children: [
                    for (final p in storefrontProducts)
                      ProductCard(
                        compact: true,
                        art: ProductArt.spec(
                          p.art,
                          tile: 22,
                          centerMark: CenterMark.circle,
                          semanticLabel: 'Product photo placeholder',
                        ),
                        title: t.productStore(p.id),
                        price: rs(p.price),
                        onTap: () => context.go('/product/${p.id}'),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Identity extends StatelessWidget {
  const _Identity({required this.maker});
  final String maker;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = MockText(l);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 58, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.shop(maker), style: AppText.fraunces(24)),
          const SizedBox(height: 4),
          Text(
            '${l.handEmbroidery} · ${t.makerCityFull(maker)}',
            style: AppText.dm(14, color: AppColors.muted),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.check,
                        size: 15,
                        color: AppColors.indigo,
                      ),
                    ),
                    TextSpan(text: ' ${l.verifiedMaker}'),
                  ],
                ),
                style: AppText.dm(
                  13,
                  weight: FontWeight.w700,
                  color: AppColors.indigo,
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    const WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: AppColors.ink,
                      ),
                    ),
                    TextSpan(text: ' 4.9 (32)'),
                  ],
                ),
                style: AppText.dm(13),
              ),
              MixedText(l.soldCount('58'), style: AppText.dm(13)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: l.message,
                  icon: Icons.chat_bubble_outline,
                  height: 44,
                  fontSize: 15,
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SecondaryButton(
                  label: l.followShop,
                  height: 44,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Semantics(
                  button: true,
                  label: l.playVoice,
                  excludeSemantics: true,
                  child: Material(
                    color: AppColors.indigo,
                    shape: const CircleBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {},
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      style: AppText.dm(13, height: 1.45),
                      children: [
                        const TextSpan(
                          text:
                              '"My mother taught me phulkari when I was ten. Every piece carries her stitches." ',
                        ),
                        TextSpan(
                          text: '· 0:15',
                          style: AppText.dm(
                            13,
                            color: AppColors.muted,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.tabs,
    required this.selected,
    required this.onSelected,
  });

  final List<String> tabs;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: UnderlineTabs(
        tabs: tabs,
        selected: selected,
        onSelected: onSelected,
      ),
    );
  }
}

/// Faint diamond lattice behind the storefront header (32 px tile).
class _LatticePainter extends CustomPainter {
  const _LatticePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.madderTint);
    final stroke = Paint()
      ..color = AppColors.madder.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final dot = Paint()..color = AppColors.indigo.withValues(alpha: 0.35);
    // Tiles are anchored to the bottom so the lattice looks the same under a status bar.
    final yEnd = size.height;
    for (double y = yEnd - 96; y < yEnd; y += 32) {
      for (double x = 0; x < size.width; x += 32) {
        final path = Path()
          ..moveTo(x + 16, y + 6)
          ..lineTo(x + 26, y + 16)
          ..lineTo(x + 16, y + 26)
          ..lineTo(x + 6, y + 16)
          ..close();
        canvas.drawPath(path, stroke);
        canvas.drawCircle(Offset(x + 16, y + 16), 2.5, dot);
      }
    }
    if (yEnd > 96) {
      for (double y = yEnd - 96 - 32; y > -32; y -= 32) {
        for (double x = 0; x < size.width; x += 32) {
          final path = Path()
            ..moveTo(x + 16, y + 6)
            ..lineTo(x + 26, y + 16)
            ..lineTo(x + 16, y + 26)
            ..lineTo(x + 6, y + 16)
            ..close();
          canvas.drawPath(path, stroke);
          canvas.drawCircle(Offset(x + 16, y + 16), 2.5, dot);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_LatticePainter old) => false;
}
