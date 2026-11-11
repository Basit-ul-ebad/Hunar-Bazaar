import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/lang.dart';
import 'app_colors.dart';

/// Type styles from DESIGN.md: Fraunces titles, DM Sans body, Noto Nastaliq Urdu.
///
/// In Urdu mode [dm] and [fraunces] return Noto Nastaliq Urdu (line height 2.0).
/// Pass `latin: true` (or use [price]) to keep a number or brand name in Latin.
class AppText {
  AppText._();

  static TextStyle dm(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double? height,
    double? letterSpacing,
    bool latin = false,
  }) {
    if (isUrdu.value && !latin) return urdu(size, weight: weight, color: color);
    return GoogleFonts.dmSans(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle fraunces(
    double size, {
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.ink,
    double? height,
    double? letterSpacing,
    bool latin = false,
  }) {
    if (isUrdu.value && !latin) return urdu(size, weight: weight, color: color);
    return GoogleFonts.fraunces(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// All Urdu text: line height 2.0.
  static TextStyle urdu(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double height = 2.0,
  }) => GoogleFonts.notoNastaliqUrdu(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );

  /// Brand name stays Latin in every language.
  static TextStyle wordmark([double size = 22]) =>
      fraunces(size, color: AppColors.madder, letterSpacing: -0.2, latin: true);

  /// Prices and numbers: always DM Sans, even in Urdu.
  static TextStyle price(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color color = AppColors.ink,
  }) => dm(size, weight: weight, color: color, latin: true);

  /// In Urdu, "Rs 5,000" and digits inside a sentence are set in DM Sans.
  static InlineSpan mixed(String text, TextStyle style) {
    if (!isUrdu.value) return TextSpan(text: text, style: style);
    final spans = <InlineSpan>[];
    var last = 0;
    for (final m in RegExp(r'Rs\s?[\d,]+|\d[\d,.:]*').allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start), style: style));
      }
      spans.add(
        TextSpan(
          text: m.group(0),
          style: GoogleFonts.dmSans(textStyle: style),
        ),
      );
      last = m.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last), style: style));
    }
    return TextSpan(children: spans);
  }
}
