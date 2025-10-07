import 'package:flutter/material.dart';
import 'package:jobshub/hr/view/hr_dashboard.dart';
import 'package:jobshub/users/dashboard_screen.dart';

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
      home: HrDashboard(),
    );
  }
}
