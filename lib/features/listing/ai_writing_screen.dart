import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/ajrak_border.dart';
import '../../widgets/product_art.dart';
import '../../widgets/scroll_fill.dart';
import '../../widgets/step_progress.dart';
import '../../widgets/text_link.dart';
import 'listing_ai_service.dart';
import 'listing_draft.dart';

/// L2 · AI writing the listing (`/seller/new/ai`). Goes to L3 after about 3 s.
class AiWritingScreen extends StatefulWidget {
  const AiWritingScreen({super.key});

  @override
  State<AiWritingScreen> createState() => _AiWritingScreenState();
}

class _AiWritingScreenState extends State<AiWritingScreen>
    with SingleTickerProviderStateMixin {
  static const _total = Duration(seconds: 3);
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: _total,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      // No motion: show the finished state, still wait for the AI.
      _c.value = 1;
    } else {
      _c.forward();
    }
    _run();
  }

  Future<void> _run() async {
    final noMotion = MediaQuery.disableAnimationsOf(context);
    ListingSuggestion? result;
    try {
      result = await listingAi.generate(listingDraft.photos);
    } catch (_) {
      // The maker can still write the listing by hand on the next step.
    }
    await Future.wait([
      Future<void>.delayed(
        noMotion ? const Duration(milliseconds: 800) : _total,
      ),
    ]);
    if (!mounted) return;
    if (result != null) listingDraft.apply(result);
    context.go('/seller/new/details');
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  /// 0 = pending, 1 = active, 2 = done.
  int _state(int item, double v) {
    final edges = [0.27, 0.60, 0.93];
    if (v >= edges[item]) return 2;
    if (item == 0 || v >= edges[item - 1]) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final photo = listingDraft.selected;
    final items = [l.aiCheck1, l.aiCheck2, l.aiCheck3];
    return Scaffold(
      body: SafeArea(
        child: ScrollFill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: AnimatedBuilder(
              animation: _c,
              builder: (context, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const StepProgress(step: 1),
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: 260,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.line),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 220,
                            width: 260,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                photo != null
                                    ? Image.memory(photo, fit: BoxFit.cover)
                                    : const ProductArt(
                                        variant: ArtVariant.phulkari,
                                        tile: 26,
                                        motifRatio: 0.385,
                                        semanticLabel:
                                            'Your photo: phulkari dupatta',
                                      ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  top: 220 * _c.value,
                                  height: 3,
                                  child: ColoredBox(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AjrakBorder(progress: _c.value),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l.writingTitle,
                    textAlign: TextAlign.center,
                    style: AppText.fraunces(24),
                  ),
                  if (!isUrduNow(context)) ...[
                    const SizedBox(height: 4),
                    Text(
                      l.writingUrdu,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: AppText.urdu(16, color: AppColors.muted),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        for (var i = 0; i < 3; i++)
                          _CheckRow(
                            label: items[i],
                            state: _state(i, _c.value),
                            last: i == 2,
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(height: 18),
                  Text(
                    l.writtenByAi,
                    textAlign: TextAlign.center,
                    style: AppText.dm(13, color: AppColors.muted),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: TextLink(
                      l.skipWrite,
                      onTap: () => context.go('/seller/new/details'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool isUrduNow(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'ur';

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    required this.state,
    required this.last,
  });

  final String label;
  final int state;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final active = state == 1;
    return Container(
      constraints: const BoxConstraints(minHeight: 48),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.lineSoft)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: switch (state) {
              2 => Container(
                decoration: const BoxDecoration(
                  color: AppColors.indigo,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              ),
              1 => const CustomPaint(painter: _DashedCirclePainter()),
              _ => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.inputBorder, width: 2),
                ),
              ),
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                label,
                style: AppText.dm(
                  14,
                  weight: active ? FontWeight.w700 : FontWeight.w400,
                  color: state == 0 ? AppColors.muted : AppColors.ink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  const _DashedCirclePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.madder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final r = size.width / 2 - 1;
    final c = Offset(size.width / 2, size.height / 2);
    final circumference = 2 * 3.141592653589793 * r;
    const dash = 4.0, gap = 3.0;
    final n = (circumference / (dash + gap)).floor();
    final step = 2 * 3.141592653589793 / n;
    for (var i = 0; i < n; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: c, radius: r),
        i * step,
        step * dash / (dash + gap),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedCirclePainter old) => false;
}
