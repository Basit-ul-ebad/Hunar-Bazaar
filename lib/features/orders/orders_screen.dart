import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import '../../widgets/mixed_text.dart';
import '../../widgets/product_art.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/seller_bottom_nav.dart';
import '../../widgets/underline_tabs.dart';

/// O1 · Orders & earnings (`/seller/orders`).
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  static const _baseToSend = 1;
  static const _delivered = 12;
  int _tab = 0;
  final _accepted = <String>{};

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = MockText(l);
    final fresh = orders.where((o) => !_accepted.contains(o.id)).toList();
    final toSend = orders.where((o) => _accepted.contains(o.id)).toList();
    final shown = switch (_tab) {
      0 => fresh,
      1 => toSend,
      _ => <Order>[],
    };
    return Scaffold(
      bottomNavigationBar: SellerBottomNav(
        current: 2,
        onSelected: (i) => SellerNav.go(context, i),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.ordersTitle, style: AppText.fraunces(24)),
                    const SizedBox(height: 14),
                    UnderlineTabs(
                      height: 44,
                      selected: _tab,
                      onSelected: (i) => setState(() => _tab = i),
                      tabs: [
                        l.tabNew('${fresh.length}'),
                        l.tabToSend('${_baseToSend + toSend.length}'),
                        l.tabDelivered('$_delivered'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              children: [
                const _EarningsCard(),
                for (final o in shown) ...[
                  const SizedBox(height: 14),
                  _OrderCard(
                    order: o,
                    text: t,
                    canAccept: _tab == 0,
                    onAccept: () => setState(() => _accepted.add(o.id)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningsCard extends StatelessWidget {
  const _EarningsCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.end,
              runSpacing: 4,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.earnedIn,
                      style: AppText.dm(12, color: AppColors.muted),
                    ),
                    Text(rs(12400), style: AppText.fraunces(30, latin: true)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: MixedText(
                    l.allTime(rs(58300)),
                    style: AppText.dm(13, color: AppColors.muted),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Semantics(
            image: true,
            label: l.earningsChart,
            child: const SizedBox(
              height: 48,
              width: double.infinity,
              child: CustomPaint(painter: _BarsPainter()),
            ),
          ),
          const SizedBox(height: 10),
          Text(l.cashNote, style: AppText.dm(12, color: AppColors.muted)),
        ],
      ),
    );
  }
}

/// Six bars, last one in madder (320 x 48 design box, stretched to fit).
class _BarsPainter extends CustomPainter {
  const _BarsPainter();

  static const _heights = [14.0, 20.0, 18.0, 28.0, 34.0, 42.0];

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 320;
    for (var i = 0; i < 6; i++) {
      final h = _heights[i] * size.height / 48;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(i * 56 * sx, size.height - h, 40 * sx, h),
        const Radius.circular(3),
      );
      canvas.drawRRect(
        rect,
        Paint()..color = i == 5 ? AppColors.madder : AppColors.madderSoft,
      );
    }
  }

  @override
  bool shouldRepaint(_BarsPainter old) => false;
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.text,
    required this.canAccept,
    required this.onAccept,
  });

  final Order order;
  final MockText text;
  final bool canAccept;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final meta = l.orderMeta(
      text.buyer(order.buyerId),
      text.buyerCity(order.buyerId),
      text.when(order.when),
    );
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 52,
                height: 52,
                child: ProductArt.spec(
                  order.art,
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
                      text.productStore(order.productId),
                      style: AppText.dm(14, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(meta, style: AppText.dm(13, color: AppColors.muted)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(rs(order.price), style: AppText.price(15)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: l.chatWhatsApp,
                  height: 44,
                  fontSize: 13,
                  onPressed: () {},
                ),
              ),
              if (canAccept) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: Material(
                    color: AppColors.madderTint,
                    shape: const StadiumBorder(),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onAccept,
                      child: Container(
                        height: 44,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          l.acceptOrder,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.dm(13, weight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
