import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hunar_bazaar/main.dart';
import 'package:hunar_bazaar/router.dart';

/// Renders every screen at 360 px wide and checks that nothing overflows.
///
/// flutter_test draws text with the Ahem font, whose glyphs are about 1.8x wider
/// than DM Sans. So the scales below are real scale / 1.8: 0.55 stands in for
/// text scale 1.0 and 0.72 for text scale 1.3.
void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  const routes = [
    '/',
    '/product/phulkari-dupatta',
    '/maker/rukhsana',
    '/sell',
    '/sell/setup',
    '/seller',
    '/seller/new/photos',
    '/seller/new/ai',
    '/seller/new/details',
    '/seller/new/price',
    '/seller/new/preview',
    '/seller/new/done',
    '/seller/orders',
    '/gallery',
  ];

  for (final scale in [0.55, 0.72]) {
    for (final route in routes) {
      testWidgets('$route fits 360 px (Ahem scale $scale)', (tester) async {
        tester.view.physicalSize = const Size(360, 780);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        router.go(route);
        await tester.pumpWidget(
          MediaQuery(
            data: MediaQueryData(
              size: const Size(360, 780),
              textScaler: TextScaler.linear(scale),
            ),
            child: const HunarBazaarApp(),
          ),
        );
        await tester.pump(const Duration(milliseconds: 400));
        if (route == '/seller/new/ai') {
          // Let the 3 s animation finish and the app move on to the details step.
          await tester.pump(const Duration(seconds: 4));
          await tester.pump(const Duration(milliseconds: 400));
        }
        expect(tester.takeException(), isNull);
      });
    }
  }
}
