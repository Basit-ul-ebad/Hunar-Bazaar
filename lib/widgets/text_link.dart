import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'tappable.dart';

/// Underlined text link with a 44 px tap area.
class TextLink extends StatelessWidget {
  const TextLink(
    this.label, {
    super.key,
    required this.onTap,
    this.color = AppColors.indigo,
    this.size = 14,
    this.underline = true,
    this.style,
  });

  final String label;
  final VoidCallback? onTap;
  final Color color;
  final double size;
  final bool underline;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Tappable(
      onTap: onTap,
      child: Text(
        label,
        style:
            (style ?? AppText.dm(size, weight: FontWeight.w700, color: color))
                .copyWith(
                  decoration: underline ? TextDecoration.underline : null,
                  decorationColor: color,
                ),
      ),
    );
  }
}
