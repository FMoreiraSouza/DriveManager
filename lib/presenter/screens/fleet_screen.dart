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
          content: 'Outras informações',
          onClick: () {},
          onPressedOk: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
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
}

class CustomModal extends StatelessWidget {
  final String title;
  final String content;
  final Function() onClick;
  final VoidCallback onPressedOk;

  const CustomModal({
    super.key,
    required this.title,
    required this.content,
    required this.onPressedOk,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
          ),
          const SizedBox(height: 16.0),
          Text(content),
          const SizedBox(height: 16.0),
          const Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(
              Icons.edit,
            ),
            Text('Editar frota')
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: onPressedOk,
                child: const Text('Ok'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
