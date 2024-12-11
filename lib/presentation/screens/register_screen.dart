import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  static const String routename = 'RegisterScreen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormBuilderState> _formkey = GlobalKey<FormBuilderState>();
  final SupabaseClient supabase = Supabase.instance.client;

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
                    )),
                Container(
                    padding: const EdgeInsets.all(20),
                    child: FormBuilderTextField(
                        name: 'password',
                        obscureText: true,
                        decoration: InputDecoration(
                            label: const Text('Ingrese una contraseña'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )))),
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
                            content: Text(
                                'Por favor ingrese un correo y una contraseña para registrarse.')),
                      );
                      return;
                    }

                    try {
                      await supabase.auth.signUp(
                        email: email,
                        password: password,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Cuenta creada exitosamente. Verifique su correo para confirmar.')),
                      );
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Error al intentar registrar una cuenta.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Registrarse'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
