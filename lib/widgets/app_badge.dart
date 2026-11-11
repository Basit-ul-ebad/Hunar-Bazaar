import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

enum _BadgeKind { live, verified, stamp, ai }

/// Indigo means trust: live, verified maker, handmade stamp, AI.
class AppBadge extends StatelessWidget {
  const AppBadge.live({super.key, this.label = 'Live'})
    : _kind = _BadgeKind.live;
  const AppBadge.verified({super.key, this.label = 'Verified maker'})
    : _kind = _BadgeKind.verified;
  const AppBadge.stamp({super.key, this.label = 'HANDMADE IN PAKISTAN'})
    : _kind = _BadgeKind.stamp;
  const AppBadge.ai({super.key, this.label = 'AI'}) : _kind = _BadgeKind.ai;

  final String label;
  final _BadgeKind _kind;

  @override
  Widget build(BuildContext context) {
    switch (_kind) {
      case _BadgeKind.live:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.indigoTint,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: AppText.dm(
              12,
              weight: FontWeight.w700,
              color: AppColors.indigo,
            ),
          ),
        );
      case _BadgeKind.verified:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.indigoTint,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check, size: 16, color: AppColors.indigo),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: AppText.dm(
                    14,
                    weight: FontWeight.w700,
                    color: AppColors.indigo,
                  ),
                ),
              ),
            ],
          ),
        );
      case _BadgeKind.stamp:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.indigo),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: AppText.dm(
              11,
              weight: FontWeight.w700,
              color: AppColors.indigo,
              letterSpacing: 0.6,
            ),
          ),
        );
      case _BadgeKind.ai:
        return Text(
          label,
          style: AppText.dm(
            11,
            weight: FontWeight.w700,
            color: AppColors.indigo,
          ),
        );
    }
  }
}
