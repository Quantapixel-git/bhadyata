import 'package:flutter/material.dart';
import 'package:jobshub/clients/client_dashboard.dart';
import 'package:jobshub/users/dashboard_screen.dart';
import 'package:jobshub/users/login_screen.dart';

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
      // home: LoginScreen(),
      home: ClientDashboardPage(),
    );
  }
}
