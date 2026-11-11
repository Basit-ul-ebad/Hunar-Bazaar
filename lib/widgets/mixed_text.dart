import 'package:flutter/material.dart';
import '../theme/app_text.dart';

/// Text whose prices and digits stay in DM Sans when the app is in Urdu.
class MixedText extends StatelessWidget {
  const MixedText(
    this.text, {
    super.key,
    required this.style,
    this.maxLines,
    this.textAlign,
    this.overflow,
  });

  final String text;
  final TextStyle style;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) => Text.rich(
    AppText.mixed(text, style),
    maxLines: maxLines,
    textAlign: textAlign,
    overflow: overflow,
  );
}
