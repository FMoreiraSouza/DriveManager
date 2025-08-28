import 'package:drivemanager/presenter/controllers/fleet_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FleetRegisterScreen extends StatefulWidget {
  const FleetRegisterScreen({super.key});

  @override
  FleetRegisterScreenState createState() => FleetRegisterScreenState();
}

class FleetRegisterScreenState extends State<FleetRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _trackerImeiController = TextEditingController();
  late FleetRegisterController _controller;

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _controller = FleetRegisterController(
      supabase,
      _plateController,
      _brandController,
      _modelController,
      _mileageController,
      _trackerImeiController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Frota'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _plateController,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a placa do veículo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marca'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a marca do veículo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o modelo do veículo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: 'Quilometragem'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a quilometragem do veículo';
                  }
                  if (double.tryParse(value.replaceAll(',', '.')) == null) {
                    return 'Quilometragem deve ser um número válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _trackerImeiController,
                decoration: const InputDecoration(labelText: 'IMEI do Rastreador'),
                keyboardType: TextInputType.number, // Restringe a números
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o IMEI do rastreador';
                  }
                  if (int.tryParse(value) == null) {
                    return 'IMEI deve ser um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _controller.saveVehicle();
                  }
                },
                child: const Text(
                  'Salvar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  @override
  void dispose() {
    _plateController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _mileageController.dispose();
    _trackerImeiController.dispose();
    super.dispose();
  }
}
