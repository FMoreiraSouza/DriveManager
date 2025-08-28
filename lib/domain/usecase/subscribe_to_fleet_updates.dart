import 'package:drivemanager/data/repository/contract/vehicle_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscribeToFleetUpdates {
  final VehicleRepository _vehicleRepository;

  SubscribeToFleetUpdates(this._vehicleRepository);

  RealtimeChannel execute(void Function() onUpdate) {
    return Supabase.instance.client
        .channel('public:vehicles')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'vehicles',
          callback: (_) => _vehicleRepository.fetchVehicles().then((_) => onUpdate()),
        )
        .subscribe();
  }
}
