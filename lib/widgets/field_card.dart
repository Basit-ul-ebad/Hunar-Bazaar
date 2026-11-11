import 'package:flutter/material.dart';
import '../theme/app_text.dart';
import 'app_badge.dart';
import 'app_card.dart';

/// AppCard with a label row (13 bold + optional AI badge) and a borderless input.
class FieldCard extends StatelessWidget {
  const FieldCard({
    super.key,
    required this.label,
    required this.child,
    this.ai = false,
  });

  final String label;
  final Widget child;
  final bool ai;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: AppText.dm(13, weight: FontWeight.w700),
                ),
              ),
              if (ai) const AppBadge.ai(),
            ],
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
