import 'package:flutter/material.dart';

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
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _chassisController = TextEditingController();
  final TextEditingController _fuelTypeController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _loadCapacityController = TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _cnfNumberController = TextEditingController();
  final TextEditingController _cnfValidityController = TextEditingController();
  final TextEditingController _driverPhoneController = TextEditingController();
  final TextEditingController _trackerImeiController = TextEditingController();
  final TextEditingController _trackingSystemNumberController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Frota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _plateController,
                decoration: InputDecoration(
                  labelText: 'Número de Placa',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a placa do veículo.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(
                  labelText: 'Marca',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _modelController,
                decoration: InputDecoration(
                  labelText: 'Modelo',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Ano de Fabricação',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _colorController,
                decoration: InputDecoration(
                  labelText: 'Cor',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _chassisController,
                decoration: InputDecoration(
                  labelText: 'Número de Chassi',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _fuelTypeController,
                decoration: InputDecoration(
                  labelText: 'Tipo de Combustível',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _mileageController,
                decoration: InputDecoration(
                  labelText: 'Kilometragem Atual',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _loadCapacityController,
                decoration: InputDecoration(
                  labelText: 'Capacidade de Carga',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _driverNameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Motorista',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _cnfNumberController,
                decoration: InputDecoration(
                  labelText: 'Número da CNH',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _cnfValidityController,
                decoration: InputDecoration(
                  labelText: 'Data de Validade da CNH',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _driverPhoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone do Motorista',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _trackerImeiController,
                decoration: InputDecoration(
                  labelText: 'IMEI do Rastreador',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _trackingSystemNumberController,
                decoration: InputDecoration(
                  labelText: 'Número do Sistema de Rastreamento',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _observationsController,
                decoration: InputDecoration(
                  labelText: 'Observações',
                  labelStyle: TextStyle(color: Colors.grey.shade700),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.hintColor),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 12.0),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.hintColor,
                ),
                child: const Text(
                  'Salvar',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
