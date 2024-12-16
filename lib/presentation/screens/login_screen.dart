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
  bool _isLoading = false;
  final SupabaseClient supabase = Supabase.instance.client;

  // Decoración personalizada para los campos de texto

  final inputDecoration = InputDecoration(
    labelText: 'Correo Electrónico',
    labelStyle: TextStyle(color: Colors.grey[700]),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1),
      borderRadius: BorderRadius.circular(20),
    ),
    filled: true,
    fillColor: Colors.white,
  );

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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade100, Colors.blue.shade400],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FormBuilder(
                    key: _formkey,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Logo de la aplicación
                          SizedBox(
                            height: size.height * 0.2,
                            width: size.height * 0.2,
                            child: ClipOval(
                              child: Image.asset('assets/logo.png',
                                  fit: BoxFit.cover),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Título
                          Text(
                            "Inicio de Sesión",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "¡Bienvenido de nuevo! Inicia sesión y haz que tu auto recupere su esplendor.",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          // Campo de correo electrónico
                          TextSelectionTheme(
                            data: TextSelectionThemeData(
                              cursorColor: Colors.black, // Color del cursor
                              selectionColor: Colors.blue.withOpacity(
                                  0.5), // Color del texto seleccionado
                              selectionHandleColor:
                                  Colors.blue, // Color del circulito (handle)
                            ),
                            child: FormBuilderTextField(
                              name: 'email',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              enableSuggestions: true,
                              autocorrect: true,
                              autofillHints: [AutofillHints.email],
                              cursorColor: Colors.black,
                              decoration: inputDecoration.copyWith(
                                labelText: 'Ingrese su correo',
                                prefixIcon: const Icon(Icons.email_outlined,
                                    color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Campo de contraseña
                          FormBuilderTextField(
                            name: 'password',
                            obscureText: true,
                            cursorColor: Colors.black,
                            decoration: inputDecoration.copyWith(
                              labelText: 'Ingrese una contraseña',
                              prefixIcon: const Icon(Icons.lock_outline,
                                  color: Colors.blue),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Botón de inicio de sesión
                          ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    _formkey.currentState?.save();
                                    var formData = _formkey.currentState?.value;
                                    String? email = formData?['email'];
                                    String? password = formData?['password'];

                                    if (email == null || password == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Por favor ingrese sus credenciales.')),
                                      );
                                      return;
                                    }

                                    setState(() {
                                      _isLoading = true;
                                    });

                                    try {
                                      await supabase.auth.signInWithPassword(
                                        email: email,
                                        password: password,
                                      );
                                      Navigator.popAndPushNamed(
                                          context, DashboardScreen.routename);
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Error al intentar iniciar sesión. Verifique sus credenciales.')),
                                      );
                                    } finally {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(size.width * 0.6, 50),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              shadowColor: Colors.black,
                              elevation: 5,
                            ),
                            child: _isLoading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text('Iniciar sesión'),
                          ),
                          // Enlace de registro
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¿Don´t have an account?',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context,
                                      RegisterScreen
                                          .routename); // Navegación a la pantalla de registro
                                },
                                child: const Text(
                                  'Sign up',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text("or login with"),
                          const SizedBox(height: 10),
                          // Botones para iniciar sesión con Google y celular
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  const webClientId =
                                      '336709612416-hrs3tt941cdmlg14g3a457k5spcr5kad.apps.googleusercontent.com';
                                  const iosClientId =
                                      '336709612416-lmuponf9n80cqsb9j8j1b67ore44btil.apps.googleusercontent.com';
                                  final GoogleSignIn googleSignIn =
                                      GoogleSignIn(
                                    clientId: iosClientId,
                                    serverClientId: webClientId,
                                  );
                                  try {
                                    await googleSignIn
                                        .signOut(); // Asegúrate de cerrar sesión activa
                                    final googleUser =
                                        await googleSignIn.signIn();
                                    if (googleUser == null) {
                                      throw 'Usuario canceló la selección de cuenta.';
                                    }
                                    final googleAuth =
                                        await googleUser.authentication;
                                    final idToken = googleAuth.idToken;
                                    final accessToken = googleAuth.accessToken;
                                    if (idToken == null ||
                                        accessToken == null) {
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
                                          content: Text(
                                              'Error al iniciar sesión con Google: $e')),
                                    );
                                  }
                                  // Lógica para inicio de sesión con Google
                                },
                                child: SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Image.asset(
                                    'assets/icon.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              GestureDetector(
                                onTap: () {
                                  // Lógica para inicio de sesión con celular
                                },
                                child: Icon(
                                  Icons.phone,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Carga completa de pantalla
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
