import '../../core/lang.dart';
import '../../core/seller_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/ajrak_border.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/app_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/product_art.dart';
import '../../widgets/scroll_fill.dart';
import '../../widgets/text_link.dart';
import 'listing_draft.dart';

/// L6 · Live in the Bazaar (`/seller/new/done`).
class ListingLiveScreen extends StatelessWidget {
  const ListingLiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final urdu = Localizations.localeOf(context).languageCode == 'ur';
    final tips = [l.tip1, l.tip2, l.tip3];
    return Scaffold(
      body: Column(
        children: [
          const SafeArea(bottom: false, child: AjrakBorder()),
          Expanded(
            child: ScrollFill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: AppColors.indigoTint,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: AppColors.indigo,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 28,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      l.liveTitle,
                      textAlign: TextAlign.center,
                      style: AppText.fraunces(26),
                    ),
                    if (!urdu) ...[
                      const SizedBox(height: 4),
                      Text(
                        l.liveUrdu,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: AppText.urdu(16, color: AppColors.muted),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      l.liveSub,
                      textAlign: TextAlign.center,
                      style: AppText.dm(14, color: AppColors.muted),
                    ),
                    const SizedBox(height: 18),
                    AppCard(
                      padding: const EdgeInsets.all(10),
                      child: ListenableBuilder(
                        listenable: listingDraft,
                        builder: (context, _) => Row(
                          children: [
                            const SizedBox(
                              width: 64,
                              height: 64,
                              child: ProductArt(
                                variant: ArtVariant.phulkari,
                                tile: 16,
                                motifRatio: 0.375,
                                centerMark: CenterMark.none,
                                radius: BorderRadius.all(Radius.circular(8)),
                                semanticLabel: 'Product thumbnail',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (isUrdu.value ? listingDraft.titleUr : listingDraft.titleEn).trim().isEmpty
                                        ? listingDraft.titleEn
                                        : (isUrdu.value ? listingDraft.titleUr : listingDraft.titleEn),
                                    style: AppText.dm(
                                      14,
                                      weight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    rs(listingDraft.finalPrice),
                                    style: AppText.price(
                                      14,
                                      weight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            AppBadge.live(label: l.live),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.yourShopLink,
                                  style: AppText.dm(12, color: AppColors.muted),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  sellerProfile.shopName.isEmpty
                                      ? tr('My shop', 'میری دکان')
                                      : sellerProfile.shopName,
                                  style: AppText.dm(
                                    14,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          InkWell(
                            borderRadius: BorderRadius.circular(22),
                            onTap: () async {
                              final messenger = ScaffoldMessenger.of(context);
                              // TODO: use the real shop URL once the backend exists.
                              await Clipboard.setData(
                                ClipboardData(
                                  text: 'Hunar Bazaar - ${sellerProfile.shopName}',
                                ),
                              );
                              messenger.showSnackBar(
                                SnackBar(content: Text(l.linkCopied)),
                              );
                            },
                            child: Container(
                              height: 44,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.ink),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Text(
                                l.copyLink,
                                style: AppText.dm(13, weight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      l.tipsTitle,
                      style: AppText.dm(14, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    for (var i = 0; i < tips.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              '${i + 1}',
                              style: AppText.price(14, color: AppColors.madder),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(tips[i], style: AppText.dm(14)),
                            ),
                          ],
                        ),
                      ),
                    const Spacer(),
                    const SizedBox(height: 10),
                    PrimaryButton(
                      label: l.addAnother,
                      onPressed: () {
                        listingDraft.reset();
                        context.go('/seller/new/photos');
                      },
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: TextLink(
                        l.backDashboard,
                        size: 15,
                        onTap: () => context.go('/seller'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
