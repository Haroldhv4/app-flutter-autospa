import 'package:flutter/material.dart';
import 'package:flutter_autotalleres/presentation/screens/dasboard_screen.dart';
import 'package:flutter_autotalleres/presentation/screens/register_screen.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  static const String routename = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  final SupabaseClient supabase = Supabase.instance.client;

  void getSession() {
    supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      print('event: $event, session: $session');
      switch (event) {
        case AuthChangeEvent.signedIn:
          if (session != null && mounted) {
            Navigator.popAndPushNamed(context, DashboardScreen.routename);
          }
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: FormBuilder(
            key: _formkey,
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(20)),
                SizedBox(
                  height: size.height * 0.2,
                  width: size.height * 0.2,
                  child: ClipOval(
                    child: Image.asset('assets/logo.png', fit: BoxFit.cover),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: FormBuilderTextField(
                    name: 'email',
                    decoration: InputDecoration(
                      label: const Text('Ingrese su correo'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: FormBuilderTextField(
                    name: 'password',
                    obscureText: true,
                    decoration: InputDecoration(
                      label: const Text('Ingrese una contraseña'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                ElevatedButton(
                  onPressed: () async {
                    _formkey.currentState?.save();
                    var formData = _formkey.currentState?.value;
                    String? email = formData?['email'];
                    String? password = formData?['password'];

                    if (email == null || password == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Por favor ingrese sus credenciales.')),
                      );
                      return;
                    }

                    try {
                      await supabase.auth.signInWithPassword(
                        email: email,
                        password: password,
                      );
                      Navigator.popAndPushNamed(
                          context, DashboardScreen.routename);
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Error al intentar iniciar sesión. Verifique sus credenciales.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Iniciar sesión'),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RegisterScreen.routename);
                  },
                  child: const Text(
                    '¿No tienes una cuenta? Regístrate aquí',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(),
                  onPressed: () async {
                    const webClientId =
                        '336709612416-hrs3tt941cdmlg14g3a457k5spcr5kad.apps.googleusercontent.com';
                    const iosClientId =
                        '336709612416-lmuponf9n80cqsb9j8j1b67ore44btil.apps.googleusercontent.com';

                    final GoogleSignIn googleSignIn = GoogleSignIn(
                      clientId: iosClientId,
                      serverClientId: webClientId,
                    );

                    try {
                      await googleSignIn
                          .signOut(); // Asegúrate de cerrar sesión activa
                      final googleUser = await googleSignIn.signIn();

                      if (googleUser == null) {
                        throw 'Usuario canceló la selección de cuenta.';
                      }

                      final googleAuth = await googleUser.authentication;
                      final idToken = googleAuth.idToken;
                      final accessToken = googleAuth.accessToken;

                      if (idToken == null || accessToken == null) {
                        throw 'Faltan credenciales de Google.';
                      }

                      await supabase.auth.signInWithIdToken(
                        provider: OAuthProvider.google,
                        idToken: idToken,
                        accessToken: accessToken,
                      );

                      Navigator.popAndPushNamed(
                          context, DashboardScreen.routename);
                    } catch (e) {
                      print('Error durante Google Sign-In: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Error al iniciar sesión con Google: $e')),
                      );
                    }
                  },
                  child: const Text('Inicia sesión con Google'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
