import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class UserFormScreen extends StatefulWidget {
  static const String routename = 'UserFormScreen';
  const UserFormScreen({super.key});
  @override
  _UserFormScreenState createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _contraseniaController = TextEditingController();
  String _tipoUsuario = 'Administrador';

  final key = dotenv.env['ENCRYPTION_KEY']!;

  String _encryptPassword(String password) {
    final key =
        encrypt.Key.fromUtf8(dotenv.env['ENCRYPTION_KEY']!); // Clave única
    final iv = encrypt.IV.fromLength(16); // IV aleatorio
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(password, iv: iv);
    return encrypted.base64; // Devuelve la contraseña cifrada en base64
  }

  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    final supabase = Supabase.instance.client;

    try {
      final encryptedPassword =
          _encryptPassword(_contraseniaController.text); // Cifra la contraseña

      final response = await supabase.from('usuario').insert({
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'correo': _correoController.text,
        'telefono': _telefonoController.text,
        'contraseña': encryptedPassword, // Inserta la contraseña cifrada
        'tipo_usuario': _tipoUsuario,
      }).select();

      // Verifica si la respuesta contiene datos
      if (response.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado con éxito')),
        );

        // Limpia el formulario después de registrar
        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Error: No se pudo registrar el usuario')),
        );
      }
    } catch (e) {
      // Manejo de excepciones
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar usuario: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'El nombre es obligatorio' : null,
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) =>
                    value!.isEmpty ? 'El apellido es obligatorio' : null,
              ),
              TextFormField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty
                    ? 'El correo es obligatorio'
                    : (!value.contains('@')
                        ? 'Introduce un correo válido'
                        : null),
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _contraseniaController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => value!.length < 6
                    ? 'La contraseña debe tener al menos 6 caracteres'
                    : null,
              ),
              DropdownButtonFormField<String>(
                value: _tipoUsuario,
                items: const [
                  DropdownMenuItem(
                    value: 'Administrador',
                    child: Text('Administrador'),
                  ),
                  DropdownMenuItem(
                    value: 'Mecanico',
                    child: Text('Mecánico'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _tipoUsuario = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Tipo de Usuario'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _registrarUsuario,
                child: const Text(
                  'Registrar Usuario',
                  style: TextStyle(color: Colors.amber, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
