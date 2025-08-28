import 'package:drivemanager/presenter/controllers/fleet_controller.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drivemanager/data/repository/vehicle_repository_impl.dart';
import 'package:drivemanager/data/repository/vehicle_coordinates_repository_impl.dart';
import 'package:drivemanager/view/widgets/empty_fleet_widget.dart';
import 'package:drivemanager/view/widgets/fleet_list_widget.dart';

class FleetScreen extends StatefulWidget {
  const FleetScreen({super.key});

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  late FleetController _controller;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _controller = FleetController(
      vehicleRepository: VehicleRepositoryImpl(supabase),
      coordinatesRepository: VehicleCoordinatesRepositoryImpl(supabase),
      onFleetUpdated: _updateFleetList,
      onCoordinatesUpdated: _updateCoordinatesList,
    );
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _controller.fetchFleetList();
    await _controller.fetchCoordinatesList();
    _controller.subscribeToFleetUpdates();
    _controller.subscribeToCoordinatesUpdates();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateFleetList() {
    if (mounted) {
      setState(() {});
    }
  }

  void _updateCoordinatesList() {
    if (mounted) {
      setState(() {});
    }
  }

  void _openFleetRegisterScreen() async {
    await Navigator.pushNamed(context, '/fleet_register');
    _controller.fetchFleetList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _controller.fleetList.isEmpty && !_controller.isLoading
                ? EmptyFleetWidget(onClick: _openFleetRegisterScreen)
                : FleetListWidget(
                    onButtonClick: _openFleetRegisterScreen,
                    fleetList: _controller.fleetList,
                    coordinatesList: _controller.coordinatesList,
                  ),
          ),
        ),
        if (_controller.isLoading) const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
