import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/lang.dart';
import '../../core/listing_repository.dart';
import '../../data/mock_data.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/primary_button.dart';
import 'live_listings_section.dart';

/// Detail page for a product published from the app (`/listing/:id`). OWNER: Basit.
class LiveListingScreen extends StatelessWidget {
  const LiveListingScreen({super.key, required this.listingId});
  final String listingId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      body: FutureBuilder<LiveListing?>(
        future: listingRepository.get(listingId),
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final l = snap.data;
          if (l == null) {
            return Center(child: Text(tr('Product not found', 'پروڈکٹ نہیں ملی'), style: AppText.dm(16)));
          }
          final title = tr(l.titleEn, l.titleUr).isEmpty ? l.titleEn : tr(l.titleEn, l.titleUr);
          final story = tr(l.storyEn, l.storyUr).isEmpty ? l.storyEn : tr(l.storyEn, l.storyUr);
          final note = tr(l.marketNoteEn, l.marketNoteUr);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 4 / 3,
                  child: LiveListingImage(imageB64: l.imageB64),
                ),
              ),
              const SizedBox(height: 16),
              Text(title, style: AppText.fraunces(22)),
              const SizedBox(height: 6),
              Text(
                [l.sellerName, l.city].where((e) => e.trim().isNotEmpty).join(' · '),
                style: AppText.dm(13, color: AppColors.muted),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(rs(l.price), style: AppText.price(24)),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.indigoTint,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, size: 14, color: AppColors.indigo),
                        const SizedBox(width: 4),
                        Text(
                          tr('Fair price', 'مناسب قیمت'),
                          style: AppText.dm(12, weight: FontWeight.w700, color: AppColors.indigo),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (l.priceHigh > l.priceLow) ...[
                const SizedBox(height: 4),
                Text(
                  '${rs(l.priceLow)} - ${rs(l.priceHigh)}',
                  textDirection: TextDirection.ltr,
                  style: AppText.price(13, weight: FontWeight.w400, color: AppColors.muted),
                ),
              ],
              if (story.trim().isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(story, style: AppText.dm(14, height: 1.5)),
              ],
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr('Why this price', 'یہ قیمت کیوں'), style: AppText.dm(14, weight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    _row(tr('Materials', 'مواد'), rs(l.materials)),
                    _row(tr('Hours of work', 'کام کے گھنٹے'), '${l.hours}'),
                    _row(tr('Craft value', 'ہنر کی قدر'), '+ ${(l.margin * 100).round()}%'),
                    if ((l.market - 1).abs() > 0.005)
                      _row(
                        tr('Local market', 'مقامی مارکیٹ'),
                        '${l.market > 1 ? '+' : '-'} ${((l.market - 1).abs() * 100).round()}%',
                      ),
                    if (note.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(note, style: AppText.dm(12, color: AppColors.muted)),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      tr('AI estimate, not a guarantee.', 'یہ اے آئی کا اندازہ ہے، ضمانت نہیں۔'),
                      style: AppText.dm(11, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              if (l.sellerWhatsapp.trim().isNotEmpty) ...[
                const SizedBox(height: 16),
                PrimaryButton(
                  label: tr('Message the maker on WhatsApp', 'واٹس ایپ پر رابطہ کریں'),
                  onPressed: () => _whatsapp(l, title),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  /// Opens a WhatsApp chat with the seller: buyers reach makers directly, no middleman.
  Future<void> _whatsapp(LiveListing l, String title) async {
    var n = l.sellerWhatsapp.replaceAll(RegExp(r'[^0-9]'), '');
    if (n.startsWith('0')) n = '92${n.substring(1)}';
    final msg = Uri.encodeComponent('Hi, I saw "$title" on Hunar Bazaar. Is it available?');
    await launchUrl(
      Uri.parse('https://wa.me/$n?text=$msg'),
      mode: LaunchMode.externalApplication,
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Expanded(child: Text(label, style: AppText.dm(13))),
        Text(value, textDirection: TextDirection.ltr, style: AppText.price(13)),
      ],
    ),
  );
}
