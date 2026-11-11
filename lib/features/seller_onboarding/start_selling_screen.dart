import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/product_art.dart';
import '../../widgets/scroll_fill.dart';

/// S1 · Start selling (`/sell`).
class StartSellingScreen extends StatelessWidget {
  const StartSellingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final steps = [l.sellStep1, l.sellStep2, l.sellStep3];
    final urdu = Localizations.localeOf(context).languageCode == 'ur';
    final radius = BorderRadius.circular(12);
    return Scaffold(
      body: SafeArea(
        child: ScrollFill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text('Hunar Bazaar', style: AppText.wordmark(20)),
                    ),
                    const LanguageToggle(),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: ProductArt(
                          variant: ArtVariant.phulkari,
                          tile: 28,
                          motifRatio: 0.393,
                          radius: radius,
                          semanticLabel: 'Phulkari embroidery',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          children: [
                            Expanded(
                              child: ProductArt(
                                variant: ArtVariant.ajrak,
                                tile: 22,
                                squareRatio: 0.545,
                                dotRatio: 0.114,
                                radius: radius,
                                semanticLabel: 'Ajrak block print',
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: ProductArt(
                                variant: ArtVariant.ralli,
                                ralliColors: const [
                                  AppColors.artUnbleached,
                                  AppColors.madder,
                                  AppColors.artGold,
                                  AppColors.indigo,
                                  AppColors.indigo,
                                  AppColors.artGold,
                                  AppColors.madder,
                                  AppColors.artUnbleached,
                                ],
                                radius: radius,
                                semanticLabel: 'Ralli patchwork',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(l.sellTitle, style: AppText.fraunces(27, height: 1.2)),
                if (!urdu) ...[
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      l.sellTagline,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: AppText.urdu(17, color: AppColors.muted),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                for (var i = 0; i < steps.length; i++) ...[
                  if (i > 0) const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.indigoTint,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${i + 1}',
                          style: AppText.dm(
                            13,
                            weight: FontWeight.w700,
                            color: AppColors.indigo,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(steps[i], style: AppText.dm(14))),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                const _PhoneField(),
                const SizedBox(height: 16),
                const Spacer(),
                PrimaryButton(
                  label: l.startSelling,
                  onPressed: () => context.go('/sell/setup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.phoneNumber,
          style: AppText.dm(13, weight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        // Phone numbers always read left to right, even in Urdu mode.
        Directionality(
          textDirection: TextDirection.ltr,
          child: Row(
            children: [
              Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '+92',
                  style: AppText.dm(16, weight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: _BoxField(
                  initial: '',
                  type: TextInputType.phone,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Outlined text field: 10 radius, inputBorder, white fill.
class _BoxField extends StatefulWidget {
  const _BoxField({required this.initial, this.type});
  final String initial;
  final TextInputType? type;

  @override
  State<_BoxField> createState() => _BoxFieldState();
}

class _BoxFieldState extends State<_BoxField> {
  late final _c = TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: TextField(
        controller: _c,
        keyboardType: widget.type,
        style: AppText.price(16, weight: FontWeight.w400),
        decoration: boxFieldDecoration(),
      ),
    );
  }
}

/// Shared outlined input look (S1 phone, S2 shop name and city).
InputDecoration boxFieldDecoration() {
  OutlineInputBorder b(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: c),
  );
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14),
    border: b(AppColors.inputBorder),
    enabledBorder: b(AppColors.inputBorder),
    focusedBorder: b(AppColors.ink),
  );
}
