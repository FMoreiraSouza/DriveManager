import 'package:drivemanager/data/model/vehicle.dart';
import 'package:drivemanager/data/model/vehicle_coodinates.dart';
import 'package:drivemanager/data/repository/contract/vehicle_coordinates_repository.dart';
import 'package:drivemanager/data/repository/contract/vehicle_repository.dart';
import 'package:drivemanager/domain/usecase/fetch_coordinates_list_usecase.dart';
import 'package:drivemanager/domain/usecase/fetch_fleet_list_usecase.dart';
import 'package:drivemanager/domain/usecase/subscribe_to_coordinate_updates_usecase.dart';
import 'package:drivemanager/domain/usecase/subscribe_to_fleet_updates_usecase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FleetController {
  final FetchFleetListUsecase _fetchFleetList;
  final FetchCoordinatesListUsecase _fetchCoordinatesList;
  final SubscribeToFleetUpdatesUsecase _subscribeToFleetUpdates;
  final SubscribeToCoordinatesUpdatesUsecase _subscribeToCoordinatesUpdates;
  final void Function() onFleetUpdated;
  final void Function() onCoordinatesUpdated;

  List<Vehicle> fleetList = [];
  List<VehicleCoordinates> coordinatesList = [];
  bool isLoading = true;

  late final RealtimeChannel vehicleSubscription;
  late final RealtimeChannel coordinatesSubscription;

  FleetController({
    required VehicleRepository vehicleRepository,
    required VehicleCoordinatesRepository coordinatesRepository,
    required this.onFleetUpdated,
    required this.onCoordinatesUpdated,
  })  : _fetchFleetList = FetchFleetListUsecase(vehicleRepository),
        _fetchCoordinatesList = FetchCoordinatesListUsecase(coordinatesRepository),
        _subscribeToFleetUpdates = SubscribeToFleetUpdatesUsecase(vehicleRepository),
        _subscribeToCoordinatesUpdates =
            SubscribeToCoordinatesUpdatesUsecase(coordinatesRepository);

  Future<void> fetchFleetList() async {
    isLoading = true;
    try {
      fleetList = await _fetchFleetList.execute();
    } catch (e) {
      throw Exception('Erro ao buscar lista de veículos: $e');
    } finally {
      isLoading = false;
      onFleetUpdated();
    }
  }

  Future<void> fetchCoordinatesList() async {
    try {
      coordinatesList = await _fetchCoordinatesList.execute();
      onCoordinatesUpdated();
    } catch (e) {
      throw Exception('Erro ao buscar coordenadas: $e');
    }
  }

  void subscribeToFleetUpdates() {
    vehicleSubscription = _subscribeToFleetUpdates.execute(onFleetUpdated);
  }

  void subscribeToCoordinatesUpdates() {
    coordinatesSubscription = _subscribeToCoordinatesUpdates.execute(onCoordinatesUpdated);
  }

  void dispose() {
    vehicleSubscription.unsubscribe();
    coordinatesSubscription.unsubscribe();
  }
}
