import 'package:drivemanager/presenter/controllers/fleet_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Tela para o registro de frota
class FleetRegisterScreen extends StatefulWidget {
  const FleetRegisterScreen({super.key});

  @override
  FleetRegisterScreenState createState() => FleetRegisterScreenState();
}

class FleetRegisterScreenState extends State<FleetRegisterScreen> {
  // Chave global para o formulário
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _trackerImeiController = TextEditingController();

  late FleetRegisterController _controller;

  @override
  void initState() {
    super.initState();
    // Inicializa o cliente Supabase
    final supabase = Supabase.instance.client;
    // Cria uma instância do controlador de registro de frota
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
              // Campo para a placa do veículo
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
              // Campo para a marca do veículo
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
              // Campo para o modelo do veículo
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
              // Campo para a quilometragem do veículo
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(labelText: 'Quilometragem'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a quilometragem do veículo';
                  }
                  return null;
                },
              ),
              // Campo para o IMEI do rastreador
              TextFormField(
                controller: _trackerImeiController,
                decoration: const InputDecoration(labelText: 'IMEI do Rastreador'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o IMEI do rastreador';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              // Botão para salvar os dados do veículo
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
      resizeToAvoidBottomInset: true, // Evita que o teclado sobreponha o conteúdo
    );
  }
}
