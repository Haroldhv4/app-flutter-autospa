import 'package:flutter/material.dart';
import 'package:flutter_autotalleres/presentation/screens/dasboard_screen.dart';
import 'package:flutter_autotalleres/presentation/screens/login_screen.dart';
import 'package:flutter_autotalleres/presentation/screens/register_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  String urlsupabase = dotenv.env['SUPABASE_URL'] ?? '';
  String supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  await Supabase.initialize(
    url: urlsupabase,
    anonKey: supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: LoginScreen.routename,
      routes: {
        LoginScreen.routename: (context) => const LoginScreen(),
        DashboardScreen.routename: (context) => const DashboardScreen(),
        RegisterScreen.routename: (context) => const RegisterScreen(),
      },
    );
  }
}
