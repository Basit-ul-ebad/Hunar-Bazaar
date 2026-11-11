import 'package:flutter/material.dart';
import '../core/lang.dart';
import '../theme/app_colors.dart';

/// Green "Fair price" trust badge shown on listings. OWNER: UI partner.
class FairPriceBadge extends StatelessWidget {
  const FairPriceBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.fairSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified, size: 14, color: AppColors.fair),
          const SizedBox(width: 4),
          Text(
            tr('Fair price', 'مناسب قیمت'),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.fair,
            ),
          ),
        ],
      ),
    );
  }
}
