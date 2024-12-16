import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  //Conexion
  SupabaseClient supabase = Supabase.instance.client;

  //Create
  createUser(String Text) async {
    var userType = supabase.auth.currentUser!.id;
    await supabase
        .from('usuario')
        .insert({'Text': Text, 'tipo_usuario': userType});
  }
  //Read

  //Update

  //Delte
}
