import 'package:flutter_test/flutter_test.dart';
import 'package:hunar_bazaar/app.dart';

void main() {
  testWidgets('app starts on the browse feed', (tester) async {
    await tester.pumpWidget(const HunarBazaarApp());
    expect(find.text('Hunar Bazaar'), findsWidgets);
  });
}
