import 'package:flutter/foundation.dart';

/// App-wide language switch (English <-> Urdu). Toggle with `isUrdu.value = !isUrdu.value`.
final ValueNotifier<bool> isUrdu = ValueNotifier<bool>(false);

/// Pick the right string for the current language: `tr('Browse', 'براؤز')`.
String tr(String en, String ur) => isUrdu.value ? ur : en;
