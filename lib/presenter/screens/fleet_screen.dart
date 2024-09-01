import 'dart:async';

import 'package:drivemanager/core/utils/custom_modal.dart';
import 'package:drivemanager/presenter/widgets/empty_fleet.dart';
import 'package:drivemanager/presenter/widgets/fleet_list.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FleetScreen extends StatefulWidget {
  const FleetScreen({super.key});

  @override
  State<FleetScreen> createState() => _FleetScreenState();
}

class _FleetScreenState extends State<FleetScreen> {
  List<Map<String, dynamic>> _fleetList = [];
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchFleetList();
  }

  Future<void> _fetchFleetList() async {
    final response = await _supabase.from('vehicles').select();
    setState(() {
      _fleetList = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  void dispose() {
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
