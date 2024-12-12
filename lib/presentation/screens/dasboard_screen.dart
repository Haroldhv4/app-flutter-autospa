import 'package:flutter/material.dart';
import 'package:flutter_autotalleres/presentation/screens/login_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatelessWidget {
  static const String routename = 'DashboardScreen';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SupabaseClient supabase = Supabase.instance.client;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          actions: [
            IconButton(
                onPressed: () {
                  try {
                    supabase.auth.signOut();
                    Navigator.popAndPushNamed(context, LoginScreen.routename);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Fallo logout')));
                    }
                  }
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: const Center(
          child: Text('Bienvenido'),
        ));
  }
}
