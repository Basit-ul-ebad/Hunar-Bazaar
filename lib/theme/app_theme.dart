import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text.dart';

/// Material 3 theme. Colours are set explicitly; the seed is only a starting point.
ThemeData buildAppTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.madder,
        brightness: Brightness.light,
      ).copyWith(
        primary: AppColors.madder,
        onPrimary: Colors.white,
        secondary: AppColors.indigo,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        outline: AppColors.line,
        outlineVariant: AppColors.lineSoft,
        surfaceTint: Colors.transparent,
      );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    canvasColor: AppColors.bg,
    dividerColor: AppColors.line,
    splashColor: AppColors.madderTint,
    highlightColor: Colors.transparent,
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: AppText.dm(14).fontFamily,
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
