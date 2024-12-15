import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_autotalleres/core/utils/size_utils.dart';
import 'package:flutter_autotalleres/presentation/screens/dasboard_screen.dart';
import 'package:flutter_autotalleres/presentation/screens/login_screen.dart';
import 'package:flutter_autotalleres/presentation/screens/register_screen.dart';
import 'package:flutter_autotalleres/presentation/screens/welcome_screen.dart';
import 'package:flutter_autotalleres/theme/theme_helper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          theme: theme,
          debugShowCheckedModeBanner: false,
          title: 'Material App',
          initialRoute: WelcomeScreen.routename,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
          routes: {
            WelcomeScreen.routename: (context) => const WelcomeScreen(),
            LoginScreen.routename: (context) => const LoginScreen(),
            DashboardScreen.routename: (context) => const DashboardScreen(),
            RegisterScreen.routename: (context) => const RegisterScreen(),
          },
        );
      },
    );
  }
}
