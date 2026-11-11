import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'dashed_border.dart';

/// Pill chip, 44 high. Selected: madderTint + 1.5 px madder border + bold.
class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.leading,
    this.dashed = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// 30 px round swatch (a mini ProductArt).
  final Widget? leading;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      style: AppText.dm(
        14,
        weight: selected ? FontWeight.w700 : FontWeight.w400,
      ),
    );
    final content = Padding(
      padding: EdgeInsets.fromLTRB(leading != null ? 6 : 14, 0, 14, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            ClipOval(child: SizedBox(width: 30, height: 30, child: leading)),
            const SizedBox(width: 8),
          ],
          Flexible(child: text),
        ],
      ),
    );
    final Widget body;
    if (dashed) {
      body = DashedBorder(
        radius: 22,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: SizedBox(
            height: 44,
            child: Center(widthFactor: 1, child: content),
          ),
        ),
      );
    } else {
      body = AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: ShapeDecoration(
          color: selected ? AppColors.madderTint : Colors.white,
          shape: StadiumBorder(
            side: BorderSide(
              color: selected ? AppColors.madder : AppColors.line,
              width: selected ? 1.5 : 1,
            ),
          ),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: SizedBox(
            height: 44,
            child: Center(widthFactor: 1, child: content),
          ),
        ),
      );
    }
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: Material(type: MaterialType.transparency, child: body),
    );
  }
}
