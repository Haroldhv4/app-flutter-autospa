import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const String routename = 'DashboardScreen';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Text('Bienvenido'),
    ));
  }
}
