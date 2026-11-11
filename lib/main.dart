import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/lang.dart';
import 'l10n/l10n.dart';
import 'router.dart';
import 'theme/app_theme.dart';

/// OWNER: Basit. Firebase.initializeApp goes here once `flutterfire configure` is done.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO(Basit): await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
