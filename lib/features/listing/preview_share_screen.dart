import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../core/listing_repository.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/lang.dart';
import '../../data/mock_data.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/ajrak_border.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/app_card.dart';
import '../../widgets/mixed_text.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/product_art.dart';
import '../../widgets/scroll_fill.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/step_header.dart';
import '../../widgets/step_progress.dart';
import 'listing_draft.dart';

/// L5 · Preview & share (`/seller/new/preview`).
class PreviewShareScreen extends StatefulWidget {
  const PreviewShareScreen({super.key});

  @override
  State<PreviewShareScreen> createState() => _PreviewShareScreenState();
}

class _PreviewShareScreenState extends State<PreviewShareScreen> {
  final _cardKey = GlobalKey();
  bool _busy = false;

  String _title(BuildContext context) {
    final d = listingDraft;
    final t = isUrdu.value ? d.titleUr : d.titleEn;
    return t.trim().isEmpty ? context.l10n.productDupattaFull : t;
  }

  Future<void> _publishAndShare(String message) async {
    if (_busy) return;
    setState(() => _busy = true);
    final router = GoRouter.of(context);
    try {
      await listingRepository.publish(listingDraft);
    } catch (e) {
      debugPrint('Publish to Firestore failed: $e');
    }
    try {
      final boundary =
          _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      final bytes = data!.buffer.asUint8List();
      await SharePlus.instance.share(
        ShareParams(
          text: message,
          files: [
            XFile.fromData(
              bytes,
              mimeType: 'image/png',
              name: 'hunar-bazaar-card.png',
            ),
          ],
          fileNameOverrides: const ['hunar-bazaar-card.png'],
        ),
      );
    } catch (_) {
      // Sharing is not available here; the listing is still published.
    }
    if (!mounted) return;
    setState(() => _busy = false);
    router.go('/seller/new/done');
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final t = MockText(l);
    final price = rs(listingDraft.userPrice);
    final message = l.shareMessage(price);
    final photo = listingDraft.selected;
    return Scaffold(
      body: SafeArea(
        child: ScrollFill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StepHeader(
                  title: l.stepPreview,
                  leadingLabel: l.back,
                  onLeading: () => context.go('/seller/new/price'),
                ),
                const SizedBox(height: 14),
                const StepProgress(step: 4),
                const SizedBox(height: 14),
                Text(
                  l.catalogTitle,
                  style: AppText.dm(15, weight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                Center(
                  child: RepaintBoundary(
                    key: _cardKey,
                    child: Container(
                      width: 310,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.line),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.ink.withValues(alpha: 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const AjrakBorder(),
                          SizedBox(
                            height: 230,
                            child: photo != null
                                ? Image.memory(photo, fit: BoxFit.cover)
                                : const ProductArt(
                                    variant: ArtVariant.phulkari,
                                    tile: 26,
                                    motifRatio: 0.385,
                                    semanticLabel:
                                        'Product photo placeholder: phulkari dupatta',
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _title(context),
                                  style: AppText.fraunces(17, height: 1.25),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      price,
                                      style: AppText.price(
                                        20,
                                        color: AppColors.madder,
                                      ),
                                    ),
                                    const Flexible(child: AppBadge.stamp()),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  l.catalogByline(
                                    t.makerFirst(rukhsanaId),
                                    t.makerCity(rukhsanaId),
                                  ),
                                  style: AppText.dm(13, color: AppColors.muted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.messageLabel,
                        style: AppText.dm(
                          12,
                          weight: FontWeight.w700,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      MixedText(message, style: AppText.dm(14, height: 1.45)),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: l.publishShare,
                  icon: Icons.chat_bubble_outline,
                  onPressed: _busy ? null : () => _publishAndShare(message),
                ),
                const SizedBox(height: 10),
                SecondaryButton(
                  label: l.publishOnly,
                  onPressed: _busy
                      ? null
                      : () => context.go('/seller/new/done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
