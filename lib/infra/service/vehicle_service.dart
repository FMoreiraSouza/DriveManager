// import 'package:supabase_flutter/supabase_flutter.dart';

// class VehicleService {
//   final SupabaseClient supabase;

//   // Construtor
//   VehicleService() : supabase = Supabase.instance.client {
//     // Configuração do canal e do listener
//     supabase
//         .channel('vehicles')
//         .onPostgresChanges(
//           event: PostgresChangeEvent.insert,
//           schema: 'public',
//           table: 'todos',
//           callback: handleInserts,
//         )
//         .subscribe();
//   }

//   // Método de callback
//   void handleInserts(PostgresChangeEvent event) {
//     // Lógica para tratar inserções
//     print('Novo evento de inserção: ${event.newRecord}');
//   }
// }
