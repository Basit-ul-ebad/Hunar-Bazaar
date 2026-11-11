import 'package:flutter/material.dart';
import 'core/lang.dart';
import 'features/feed/feed_screen.dart';
import 'features/sell/sell_screen.dart';
import 'features/shop/shop_screen.dart';
import 'theme/app_theme.dart';

/// App shell: theme, language direction, bottom navigation. OWNER: Basit.
class HunarBazaarApp extends StatelessWidget {
  const HunarBazaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isUrdu,
      builder: (context, urdu, _) => MaterialApp(
        title: 'Hunar Bazaar',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        builder: (context, child) => Directionality(
          textDirection: urdu ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        ),
        home: const _Shell(),
      ),
    );
  }
}

class _Shell extends StatefulWidget {
  const _Shell();

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [FeedScreen(), SellScreen(), ShopScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.storefront), label: tr('Browse', 'براؤز')),
          NavigationDestination(icon: const Icon(Icons.add_a_photo), label: tr('Sell', 'بیچیں')),
          NavigationDestination(icon: const Icon(Icons.person), label: tr('My shop', 'میری دکان')),
        ],
      ),
    );
  }
}
