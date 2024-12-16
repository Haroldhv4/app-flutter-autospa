import 'package:flutter/material.dart';
import 'package:flutter_autotalleres/presentation/screens/login_screen.dart';
import 'package:flutter_autotalleres/usuario/user_form.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardScreen extends StatelessWidget {
  static const String routename = 'DashboardScreen';
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SupabaseClient supabase = Supabase.instance.client;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/fondo.jpg",
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "SELECCIONE UN APARTADO",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 80),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildGridButton(context, Icons.car_repair,
                          "Crear Usuario", UserFormScreen.routename),
                      _buildGridButton(
                          context, Icons.format_paint, "Pintura", '/pintura'),
                      _buildGridButton(
                          context, Icons.build, "Taller", '/taller'),
                      _buildGridButton(context, Icons.handyman, "Herramientas",
                          '/herramientas'),
                      _buildGridButton(context, Icons.settings, "Configuración",
                          '/configuracion'),
                      _buildGridButton(
                          context, Icons.person, "Clientes", '/clientes'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(
      BuildContext context, IconData icon, String label, String route) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 50, color: Colors.white),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pushNamed(route); // Aquí usamos 'route' directamente
          },
          child: Text(label),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
