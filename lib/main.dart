import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ add this
import 'package:jobshub/common/views/splash_screen.dart';

void main() async {
  // ✅ Ensure all Flutter bindings and plugins are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Optionally initialize SharedPreferences (not strictly required but safe)
  await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BADHYATA',
      home: SplashScreen(),
    );
  }
}
