import 'package:flutter/material.dart';
import 'package:keepmoney/screens/dashboard_screen.dart';
import 'package:keepmoney/screens/home_screen.dart';
import 'package:keepmoney/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/homescreen',
      routes: _buildRoutes(),
    );
  }

  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      '/homescreen': (context) => const HomeScreen(),
      '/registerscreen': (context) => const RegisterScreen(),
      '/dashboardscreen': (context) => const DashBoardScreen(),
    };
  }
}