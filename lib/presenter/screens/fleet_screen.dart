import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drivemanager/core/utils/custom_modal.dart';
import 'package:drivemanager/presenter/widgets/empty_fleet.dart';
import 'package:drivemanager/presenter/widgets/fleet_list.dart';

class FleetScreen extends StatefulWidget {
  const FleetScreen({super.key});

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  List<Map<String, dynamic>> _fleetList = [];
  List<Map<String, dynamic>> _coordinatesList = [];
  final SupabaseClient _supabase = Supabase.instance.client;
  late final RealtimeChannel _vehicleSubscription;
  late final RealtimeChannel _coordinatesSubscription;

  @override
  void initState() {
    super.initState();
    _fetchFleetList();
    _fetchCoordinatesList();
    _subscribeToFleetUpdates();
    _subscribeToCoordinatesUpdates();
  }

  Future<void> _fetchFleetList() async {
    final response = await _supabase.from('vehicles').select();

    setState(() {
      _fleetList = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> _fetchCoordinatesList() async {
    final response = await _supabase.from('vehicle_coordinates').select();
    setState(() {
      _coordinatesList = List<Map<String, dynamic>>.from(response);
    });
  }

  void _subscribeToFleetUpdates() {
    _vehicleSubscription = _supabase
        .channel('public:vehicles')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'vehicles',
            callback: (payload) {
              _fetchFleetList();
            })
        .subscribe();
  }

  void _subscribeToCoordinatesUpdates() {
    _coordinatesSubscription = _supabase
        .channel('public:vehicle_coordinates')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'vehicle_coordinates',
            callback: (payload) {
              _fetchCoordinatesList();
            })
        .subscribe();
  }

  @override
  void dispose() {
    _vehicleSubscription.unsubscribe();
    _coordinatesSubscription.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _fleetList.isEmpty
            ? EmptyFleet(onClick: _openFleetRegisterScreen)
            : FleetList(
                onCardClick: _showCustomModal,
                onButtonClick: _openFleetRegisterScreen,
                fleetList: _fleetList,
                coordinatesList: _coordinatesList,
              ),
      ),
    );
  }

  void _openFleetRegisterScreen() async {
    await Navigator.pushNamed(context, '/fleet-register');
    _fetchFleetList();
  }

  Future<void> _showCustomModal(Map<String, dynamic> vehicle) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CustomModal(
          title: vehicle['plate_number'] ?? 'Sem placa',
          content: 'Quilometragem: ${vehicle['mileage']} km\nOutras informações',
          onClick: () {},
          onPressedOk: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
