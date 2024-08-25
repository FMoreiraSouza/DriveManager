import 'package:flutter/material.dart';
import 'package:drivemanager/presenter/routes/navigation_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FleetListScreen extends StatefulWidget {
  const FleetListScreen({super.key});

  @override
  State<FleetListScreen> createState() => _FleetListScreenState();
}

class _FleetListScreenState extends State<FleetListScreen> {
    List<Map<String, dynamic>> _fleetList = [];

 final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchFleetList(); // Buscar a lista ao iniciar o estado
  }

  Future<void> _fetchFleetList() async {
    final response = await _supabase
        .from('vehicles')
        .select();        

    
      setState(() {
        _fleetList = List<Map<String, dynamic>>.from(response);
      });
  
  }

  void _openFleetRegisterScreen() async {
    await Navigator.pushNamed(context, '/fleet-register');
    _fetchFleetList();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        
        child: _fleetList.isEmpty ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sem frota cadastrada',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 18),
            ),
            GestureDetector(
              onTap: () {
                _openFleetRegisterScreen();
              },
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4.0),
                  onTap: () {
                    NavigationService.pushNamed('/fleet-register');
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Comece já!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Image.asset('assets/images/register_your_fleet.png'),
          ],
        ): Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: ListView.builder(
                      itemCount: _fleetList.length,
                      itemBuilder: (context, index) {
                        final vehicle = _fleetList[index];
                        return ListTile(
                          title: Text(vehicle['plate_number'] ?? 'Sem placa'),
                          subtitle:
                              Text('${vehicle['brand']} ${vehicle['model']}'),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: FloatingActionButton(
                      onPressed: _openFleetRegisterScreen,
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
