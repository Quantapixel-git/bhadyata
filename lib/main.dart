import 'package:flutter/material.dart';
import 'package:jobshub/admin/admin_dashboard.dart';
import 'package:jobshub/common/views/splash_screen.dart';
import 'package:jobshub/hr/view/hr_dashboard.dart';

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
