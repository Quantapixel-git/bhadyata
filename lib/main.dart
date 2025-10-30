import 'package:flutter/material.dart';
import 'package:jobshub/common/views/splash_screen.dart';
// import 'package:jobshub/users/view/auth/login_screen.dart';

void main() {
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
