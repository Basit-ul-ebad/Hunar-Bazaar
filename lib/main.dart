import 'package:flutter/material.dart';
import 'app.dart';

/// OWNER: Basit. Firebase.initializeApp goes here once `flutterfire configure` is done.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO(Basit): await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const HunarBazaarApp());
}
