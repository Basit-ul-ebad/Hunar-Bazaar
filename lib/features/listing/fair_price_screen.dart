import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/lang.dart';
import '../../data/mock_data.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import '../../widgets/mixed_text.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/scroll_fill.dart';
import '../../widgets/step_header.dart';
import '../../widgets/step_progress.dart';
import '../../widgets/tappable.dart';
import 'listing_draft.dart';
import 'pricing_calc.dart';
import 'rs_formatter.dart';

/// L4 · Fair price (`/seller/new/price`). The price is calculated in code.
class FairPriceScreen extends StatefulWidget {
  const FairPriceScreen({super.key});

  @override
  State<FairPriceScreen> createState() => _FairPriceScreenState();
}

class _FairPriceScreenState extends State<FairPriceScreen> {
  late final _materials = TextEditingController(
    text: rs(listingDraft.materials),
  );
  late final _mine = TextEditingController(text: rs(listingDraft.userPrice));

  @override
  void dispose() {
    _materials.dispose();
    _mine.dispose();
    super.dispose();
  }

  InputDecoration _box({
    Color border = AppColors.inputBorder,
    double width = 1,
  }) {
    OutlineInputBorder b(Color c, double w) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: c, width: w),
    );
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      border: b(border, width),
      enabledBorder: b(border, width),
      focusedBorder: b(border, width + 0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: ScrollFill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
            child: ListenableBuilder(
              listenable: listingDraft,
              builder: (context, _) {
                final d = listingDraft;
                final s = d.suggestion;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StepHeader(
                      title: l.stepPrice,
                      leadingLabel: l.back,
                      onLeading: () => context.go('/seller/new/details'),
                      trailing: Semantics(
                        button: true,
                        label: l.tellByVoice,
                        excludeSemantics: true,
                        child: Material(
                          color: AppColors.indigoTint,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () {},
                            child: const SizedBox(
                              width: 44,
                              height: 44,
                              child: Icon(
                                Icons.mic_none,
                                size: 20,
                                color: AppColors.indigo,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const StepProgress(step: 3),
                    const SizedBox(height: 14),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _materialsCard(l, d)),
                        const SizedBox(width: 10),
                        Expanded(child: _timeCard(l, d)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _priceCard(l, d, s),
                    const SizedBox(height: 14),
                    AppCard(
                      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.yourPrice,
                                  style: AppText.dm(
                                    14,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  l.youDecide,
                                  style: AppText.dm(12, color: AppColors.muted),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 130,
                            height: 48,
                            child: TextField(
                              controller: _mine,
                              keyboardType: TextInputType.number,
                              expands: true,
                              maxLines: null,
                              textAlignVertical: TextAlignVertical.center,
                              inputFormatters: [RsFormatter()],
                              style: AppText.price(18),
                              decoration: _box(
                                border: AppColors.madder,
                                width: 1.5,
                              ),
                              onChanged: (v) =>
                                  listingDraft.setUserPrice(parseRs(v)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(height: 14),
                    PrimaryButton(
                      label: l.nextPreview,
                      onPressed: () => context.go('/seller/new/preview'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _materialsCard(dynamic l, ListingDraft d) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.materialsCost, style: AppText.dm(13, weight: FontWeight.w700)),
        const SizedBox(height: 6),
        SizedBox(
          height: 44,
          child: TextField(
            controller: _materials,
            keyboardType: TextInputType.number,
            expands: true,
            maxLines: null,
            textAlignVertical: TextAlignVertical.center,
            inputFormatters: [RsFormatter()],
            style: AppText.price(16),
            decoration: _box(),
            onChanged: (v) => listingDraft.setMaterials(parseRs(v)),
          ),
        ),
        const SizedBox(height: 6),
        Text(l.clothThread, style: AppText.dm(12, color: AppColors.muted)),
      ],
    ),
  );

  Widget _timeCard(dynamic l, ListingDraft d) => AppCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l.timeSpent, style: AppText.dm(13, weight: FontWeight.w700)),
        const SizedBox(height: 6),
        SizedBox(
          height: 44,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RoundStep(
                Icons.remove,
                l.less,
                () => listingDraft.setDays(d.days - 1),
              ),
              Flexible(
                child: MixedText(
                  l.daysN(d.days),
                  style: AppText.dm(16, weight: FontWeight.w700),
                ),
              ),
              _RoundStep(
                Icons.add,
                l.more,
                () => listingDraft.setDays(d.days + 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        MixedText(
          l.hoursOfWork('${d.hours}'),
          style: AppText.dm(12, color: AppColors.muted),
        ),
      ],
    ),
  );

  Widget _priceCard(dynamic l, ListingDraft d, PriceSuggestion s) {
    final pos = thumbPosition(d.userPrice, s);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.line),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.worthTitle,
                  style: AppText.dm(15, weight: FontWeight.w700),
                ),
              ),
              Text(
                l.aiAssisted,
                style: AppText.dm(
                  11,
                  weight: FontWeight.w700,
                  color: AppColors.indigo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(rs(s.fair), style: AppText.fraunces(36, height: 1, latin: true)),
          const SizedBox(height: 12),
          // Track: low-high band fills 10%-90%; the thumb follows the user's price.
          // (No LayoutBuilder here: the screen sits inside an IntrinsicHeight.)
          SizedBox(
            height: 8,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.field,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.madderSoft,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: -6,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      widthFactor: pos,
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: FractionalTranslation(
                          translation: Offset(
                            Directionality.of(context) == TextDirection.rtl
                                ? -0.5
                                : 0.5,
                            0,
                          ),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.madder,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.ink.withValues(alpha: 0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: MixedText(
                  l.lowLabel(rs(s.low)),
                  style: AppText.dm(12, color: AppColors.muted),
                ),
              ),
              Text(l.fairLabel, style: AppText.dm(12, color: AppColors.muted)),
              Expanded(
                child: MixedText(
                  l.highLabel(rs(s.high)),
                  textAlign: TextAlign.end,
                  style: AppText.dm(12, color: AppColors.muted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.lineSoft),
          const SizedBox(height: 10),
          _line(l.breakdownMaterials, rs(d.materials)),
          const SizedBox(height: 8),
          _line(l.yourTime('${d.hours}', rs(kHourlyRate)), rs(s.timeValue)),
          const SizedBox(height: 8),
          _line(l.handValue, '+ ${(s.margin * 100).round()}%'),
          if ((d.market - 1).abs() > 0.005) ...[
            const SizedBox(height: 8),
            _line(
              tr('Market in ${d.cityName}', '${d.cityName} کی مارکیٹ'),
              '${d.market > 1 ? '+' : '-'} ${((d.market - 1).abs() * 100).round()}%',
            ),
            const SizedBox(height: 6),
            Text(
              tr(d.marketNoteEn, d.marketNoteUr),
              style: AppText.dm(12, color: AppColors.muted),
            ),
          ],
          const SizedBox(height: 12),
          Tappable(
            onTap: () {},
            child: Text(
              l.listenWhy,
              style: AppText.dm(
                13,
                weight: FontWeight.w700,
                color: AppColors.indigo,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(String label, String value) => Row(
    children: [
      Expanded(child: MixedText(label, style: AppText.dm(14))),
      const SizedBox(width: 8),
      Text(value, textDirection: TextDirection.ltr, style: AppText.price(14)),
    ],
  );
}

class _RoundStep extends StatelessWidget {
  const _RoundStep(this.icon, this.label, this.onTap);
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tappable(
    onTap: onTap,
    semanticLabel: label,
    radius: BorderRadius.circular(20),
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Icon(icon, size: 18, color: AppColors.ink),
    ),
  );
}
