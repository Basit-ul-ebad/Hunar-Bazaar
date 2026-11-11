import 'package:flutter/material.dart';
import '../core/lang.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Pill group "اردو | English". Reads and writes the app-wide [isUrdu] switch.
class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key, this.compact = false});

  /// Compact form shows "اردو | EN".
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isUrdu,
      builder: (context, urdu, _) {
        return Container(
          padding: const EdgeInsets.all(3),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: const StadiumBorder(side: BorderSide(color: AppColors.line)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Option(
                label: 'اردو',
                style: AppText.urdu(14, height: 1.2),
                selected: urdu,
                onTap: () => isUrdu.value = true,
              ),
              _Option(
                label: compact ? 'EN' : 'English',
                style: AppText.dm(13, weight: FontWeight.w700),
                selected: !urdu,
                onTap: () => isUrdu.value = false,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.style,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final TextStyle style;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        decoration: ShapeDecoration(
          color: selected ? AppColors.madderTint : Colors.white,
          shape: const StadiumBorder(),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Container(
            height: 36,
            constraints: const BoxConstraints(minWidth: 44),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            child: Text(label, style: style),
          ),
        ),
      ),
    );
  }
}
