import 'package:flutter/material.dart';

/// Colour tokens from DESIGN.md section 2. Nothing else is allowed in UI chrome.
class AppColors {
  AppColors._();

  static const bg = Color(0xFFFAF7F2);
  static const surface = Color(0xFFFFFFFF);
  static const line = Color(0xFFE8E1D8);
  static const lineSoft = Color(0xFFF0EAE2);
  static const inputBorder = Color(0xFFCFC6BB);
  static const ink = Color(0xFF2B2422);
  static const muted = Color(0xFF6B615C);
  static const madder = Color(0xFFB94E36);
  static const madderTint = Color(0xFFFBEDE7);
  static const madderSoft = Color(0xFFF2C9BC);
  static const indigo = Color(0xFF33568C);
  static const indigoTint = Color(0xFFEBF0F7);

  /// Search-field fill and empty ajrak-strip track (used in the design HTML/spec).
  static const field = Color(0xFFF3EEE7);

  // Product-art only: placeholders that stand in for real photos.
  static const artGold = Color(0xFFE2B04A);
  static const artUnbleached = Color(0xFFF5EFE6);
  static const artSkin = Color(0xFFE9C9B8);
}
