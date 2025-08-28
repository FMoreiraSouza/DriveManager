import 'package:drivemanager/data/repository/contract/vehicle_coordinates_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SubscribeToCoordinatesUpdatesUsecase {
  final VehicleCoordinatesRepository _vehicleCoordinatesRepository;

  SubscribeToCoordinatesUpdatesUsecase(this._vehicleCoordinatesRepository);

  RealtimeChannel execute(void Function() onUpdate) {
    return Supabase.instance.client
        .channel('public:vehicle_coordinates')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'vehicle_coordinates',
          callback: (_) => _vehicleCoordinatesRepository.fetchCoordinates().then((_) => onUpdate()),
        )
        .subscribe();
  }
}
