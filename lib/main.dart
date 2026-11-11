import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/demo_seed.dart';
import 'core/gemini_listing_ai.dart';
import 'core/listing_repository.dart';
import 'core/lang.dart';
import 'features/listing/listing_ai_service.dart';
import 'firebase_options.dart';
import 'l10n/l10n.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// OWNER: Basit. Firebase + anonymous sign-in + real Gemini; falls back to the mock AI if Firebase fails.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    listingAi = GeminiListingAiService();
  } catch (e) {
    debugPrint('Firebase init failed, using mock AI: $e');
  }
  try {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signInAnonymously();
    }
  } catch (e) {
    debugPrint('Anonymous sign-in failed (enable it in Firebase console): $e');
  }
  try {
    await listingRepository.loadSeller().timeout(const Duration(seconds: 5));
  } catch (e) {
    debugPrint('Could not load seller profile: $e');
  }
  // First run on an empty database: add a few demo products (runs in the background).
  seedDemoListingsIfEmpty().catchError((Object e) {
    debugPrint('Demo seed skipped: $e');
  });
  runApp(const HunarBazaarApp());
}

class HunarBazaarApp extends StatelessWidget {
  const HunarBazaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isUrdu,
      builder: (context, urdu, _) => MaterialApp.router(
        title: 'Hunar Bazaar',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        routerConfig: router,
        // Urdu switches the whole app to right-to-left.
        locale: Locale(urdu ? 'ur' : 'en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, child) {
          // Debug only: open the web build with ?scale=1.3 to check large text.
          final s = double.tryParse(Uri.base.queryParameters['scale'] ?? '');
          Widget page = child!;
          if (kDebugMode && s != null) {
            page = MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(s)),
              child: page,
            );
          }
          // Fonts are chosen per language, so rebuild every page on a switch.
          // Draft data lives outside the widgets, so nothing is lost.
          return KeyedSubtree(key: ValueKey(urdu), child: page);
        },
      ),
    );
  }
}
