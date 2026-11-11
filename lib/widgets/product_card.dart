import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'product_art.dart';

/// Product tile: image, title, price, "by Maker · City". [compact] is the storefront size.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.art,
    required this.title,
    required this.price,
    this.byline,
    this.compact = false,
    this.onTap,
  });

  /// Usually a [ProductArt]; sized by the card (150 h, or 120 h when compact).
  final Widget art;
  final String title;
  final String price;
  final String? byline;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.line),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: compact ? 120 : 150, child: art),
            Padding(
              padding: compact
                  ? const EdgeInsets.fromLTRB(10, 8, 10, 10)
                  : const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: compact ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.dm(
                      compact ? 13 : 14,
                      weight: FontWeight.w500,
                      height: compact ? null : 1.3,
                    ),
                  ),
                  SizedBox(height: compact ? 2 : 4),
                  Text(price, style: AppText.price(compact ? 15 : 16)),
                  if (byline != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      byline!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.dm(12, color: AppColors.muted),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
