import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/lang.dart';
import '../../core/listing_repository.dart';
import '../../data/mock_data.dart' show rs;
import '../../theme/app_colors.dart';
import '../../theme/app_text.dart';
import '../../widgets/product_card.dart';
import '../../widgets/two_column_grid.dart';

/// Product photo from a Firestore listing (base64), or a plain placeholder. OWNER: Basit.
class LiveListingImage extends StatelessWidget {
  const LiveListingImage({super.key, required this.imageB64, this.fit = BoxFit.cover});
  final String? imageB64;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final b = imageB64;
    if (b != null && b.isNotEmpty) {
      return Image.memory(
        base64Decode(b),
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        gaplessPlayback: true,
      );
    }
    return Container(
      color: AppColors.madderTint,
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, color: AppColors.madder, size: 40),
    );
  }
}

/// All products for sale, live from Firestore (the whole marketplace). OWNER: Basit.
class LiveListingsSection extends StatelessWidget {
  const LiveListingsSection({super.key});

  Stream<List<LiveListing>>? _stream() {
    try {
      return listingRepository.watchAll(limit: 40);
    } catch (_) {
      return null; // Firebase not initialised
    }
  }

  @override
  Widget build(BuildContext context) {
    final stream = _stream();
    final title = Text(
      tr('Fresh from makers', 'کاریگروں سے تازہ'),
      style: AppText.dm(16, weight: FontWeight.w700),
    );
    if (stream == null) {
      return _message(title, tr('Could not connect. Check your internet.', 'کنکشن نہیں ہو سکا۔ انٹرنیٹ چیک کریں۔'));
    }
    return StreamBuilder<List<LiveListing>>(
      stream: stream,
      builder: (context, snap) {
        if (snap.hasError) {
          return _message(title, tr('Could not load products.', 'پروڈکٹس لوڈ نہیں ہو سکیں۔'));
        }
        if (!snap.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              title,
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
            ],
          );
        }
        final items = snap.data!;
        if (items.isEmpty) {
          return _message(
            title,
            tr('No products yet. Be the first to sell!', 'ابھی کوئی پروڈکٹ نہیں۔ سب سے پہلے آپ بیچیں!'),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            const SizedBox(height: 10),
            TwoColumnGrid(
              children: [
                for (final l in items)
                  ProductCard(
                    art: LiveListingImage(imageB64: l.imageB64),
                    title: tr(l.titleEn, l.titleUr).isEmpty ? l.titleEn : tr(l.titleEn, l.titleUr),
                    price: rs(l.price),
                    byline: [l.sellerName, l.city].where((e) => e.trim().isNotEmpty).join(' · '),
                    onTap: () => context.go('/listing/${l.id}'),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _message(Widget title, String text) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      title,
      const SizedBox(height: 16),
      Text(text, style: AppText.dm(14, color: AppColors.muted)),
    ],
  );
}
