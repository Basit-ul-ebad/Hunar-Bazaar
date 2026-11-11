import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// White pill with a 1 px ink border.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.height = 48,
    this.fontSize = 15,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double fontSize;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: Colors.white,
      shape: const StadiumBorder(
        side: BorderSide(color: AppColors.ink, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.dm(fontSize, weight: FontWeight.w700),
          ),
        ),
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
