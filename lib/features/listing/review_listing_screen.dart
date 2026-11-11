import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/lang.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/app_card.dart';
import '../../widgets/field_card.dart';
import '../../widgets/language_toggle.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/scroll_fill.dart';
import '../../widgets/step_header.dart';
import '../../widgets/step_progress.dart';
import '../../widgets/tappable.dart';
import 'listing_ai_service.dart';
import 'listing_draft.dart';

/// L3 · Review listing (`/seller/new/details`). Text follows the app language.
class ReviewListingScreen extends StatefulWidget {
  const ReviewListingScreen({super.key});

  @override
  State<ReviewListingScreen> createState() => _ReviewListingScreenState();
}

class _ReviewListingScreenState extends State<ReviewListingScreen> {
  late final TextEditingController _title;
  late final TextEditingController _story;

  @override
  void initState() {
    super.initState();
    final d = listingDraft;
    _title = TextEditingController(text: isUrdu.value ? d.titleUr : d.titleEn);
    _story = TextEditingController(text: isUrdu.value ? d.storyUr : d.storyEn);
  }

  @override
  void dispose() {
    _title.dispose();
    _story.dispose();
    super.dispose();
  }

  Future<void> _writeAgain() async {
    try {
      final ListingSuggestion s = await listingAi.rewrite(listingDraft.photos);
      if (!mounted) return;
      listingDraft.apply(s);
      _story.text = isUrdu.value ? s.storyUr : s.storyEn;
    } catch (_) {
      // Keep the current text if the AI is unavailable.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    InputDecoration bare() => const InputDecoration(
      isDense: true,
      border: InputBorder.none,
      contentPadding: EdgeInsets.zero,
    );
    return Scaffold(
      body: SafeArea(
        child: ScrollFill(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StepHeader(
                  title: l.stepDetails,
                  leadingLabel: l.back,
                  onLeading: () => context.go('/seller/new/photos'),
                  trailing: const LanguageToggle(compact: true),
                ),
                const SizedBox(height: 12),
                const StepProgress(step: 2),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.indigoTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'AI',
                          style: AppText.dm(
                            13,
                            weight: FontWeight.w700,
                            color: AppColors.indigo,
                            latin: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l.aiNote,
                          style: AppText.dm(13, color: AppColors.indigo),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FieldCard(
                  label: l.fieldTitle,
                  ai: true,
                  child: TextField(
                    controller: _title,
                    minLines: 1,
                    maxLines: 3,
                    style: AppText.dm(16, weight: FontWeight.w500),
                    decoration: bare(),
                    onChanged: (v) => isUrdu.value
                        ? listingDraft.titleUr = v
                        : listingDraft.titleEn = v,
                  ),
                ),
                const SizedBox(height: 12),
                AppCard(
                  onTap: () {},
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l.fieldCategory,
                              style: AppText.dm(13, weight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(l.categoryValue, style: AppText.dm(15)),
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
                const SizedBox(height: 12),
                FieldCard(
                  label: l.fieldStory,
                  ai: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _story,
                        minLines: 4,
                        maxLines: 8,
                        style: AppText.dm(14, height: 1.5),
                        decoration: bare(),
                        onChanged: (v) => isUrdu.value
                            ? listingDraft.storyUr = v
                            : listingDraft.storyEn = v,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _TextAction(l.writeAgain, _writeAgain),
                          const SizedBox(width: 16),
                          _TextAction(l.listen, () {}),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                AppCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Column(
                    children: [
                      _DetailRow(l.detailMaterial, l.detailMaterialValue),
                      _DetailRow(l.detailTechnique, l.detailTechniqueValue),
                      _DetailRow(l.detailSize, l.detailSizeValue, last: true),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: l.nextSetPrice,
                  onPressed: () => context.go('/seller/new/price'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tappable(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        label,
        style: AppText.dm(13, weight: FontWeight.w700, color: AppColors.indigo),
      ),
    ),
  );
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value, {this.last = false});
  final String label, value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(bottom: BorderSide(color: AppColors.lineSoft)),
      ),
      child: Row(
        children: [
          Text(label, style: AppText.dm(14, color: AppColors.muted)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppText.dm(14, weight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
