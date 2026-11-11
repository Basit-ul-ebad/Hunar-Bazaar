import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// 44 circle back/close button, centred "Step N of 4 · Label", trailing slot.
class StepHeader extends StatelessWidget {
  const StepHeader({
    super.key,
    required this.title,
    required this.onLeading,
    this.leadingIcon = Icons.arrow_back_ios_new_rounded,
    required this.leadingLabel,
    this.trailing,
  });

  final String title;
  final VoidCallback onLeading;
  final IconData leadingIcon;
  final String leadingLabel;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleIconButton(
          icon: leadingIcon,
          label: leadingLabel,
          onTap: onLeading,
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppText.dm(14, weight: FontWeight.w700),
          ),
        ),
        trailing ?? const SizedBox(width: 44, height: 44),
      ],
    );
  }
}

/// 44 px round button: white, 1 px line border (used for back, saved, close).
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.bordered = true,
    this.iconSize = 20,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool bordered;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: Material(
        color: Colors.white,
        shape: CircleBorder(
          side: bordered
              ? const BorderSide(color: AppColors.line)
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, size: iconSize, color: AppColors.ink),
          ),
        ),
      ),
    );
  }
}
