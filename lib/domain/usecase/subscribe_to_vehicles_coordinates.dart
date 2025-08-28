import 'package:drivemanager/data/model/vehicle_coodinates.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscribeToVehicleCoordinates {
  final SupabaseClient _supabase;

  SubscribeToVehicleCoordinates(this._supabase);

  RealtimeChannel execute(void Function(VehicleCoordinates) onUpdate) {
    return _supabase
        .channel('public:vehicle_coordinates')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'vehicle_coordinates',
          callback: (payload) {
            final record = payload.newRecord;
            onUpdate(VehicleCoordinates.fromMap(Map<String, dynamic>.from(record)));
          },
        )
        .subscribe();
  }
}
