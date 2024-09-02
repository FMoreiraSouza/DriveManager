// Importa pacotes necessários para o funcionamento do widget.
import 'package:drivemanager/presenter/routes/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Define a tela para registrar um novo veículo na frota.
class FleetRegisterScreen extends StatefulWidget {
  // Construtor padrão para a tela de registro de frota.
  const FleetRegisterScreen({super.key});

  @override
  FleetRegisterScreenState createState() => FleetRegisterScreenState();
}

// Estado da tela de registro de frota.
class FleetRegisterScreenState extends State<FleetRegisterScreen> {
  // Chave para identificar o formulário.
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto do formulário.
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _trackerImeiController = TextEditingController();

  // Instância do cliente Supabase para interagir com o banco de dados.
  final SupabaseClient _supabase = Supabase.instance.client;

  // Função assíncrona para salvar os dados do veículo.
  Future<void> _saveVehicle() async {
    // Cria um mapa com os dados do veículo a partir dos controladores.
    final newVehicle = {
      'plate_number': _plateController.text,
      'brand': _brandController.text,
      'model': _modelController.text,
      'mileage': _mileageController.text,
      'tracker_imei': _trackerImeiController.text,
    };

    // Insere os dados do veículo na tabela 'vehicles' do banco de dados.
    final response = await _supabase.from('vehicles').insert(newVehicle);

    // Verifica se a resposta é nula, indicando sucesso.
    if (response == null) {
      // Retorna à tela anterior com os dados do novo veículo.
      NavigationService.goBack(result: newVehicle);
    } else {
      // Exibe uma mensagem de erro caso a inserção falhe.
      NavigationService.showSnackBar('Erro ao salvar veículo: ${response.error?.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Constrói o layout da tela.
    return Scaffold(
      // Configura a AppBar da tela com o título.
      appBar: AppBar(
        title: const Text('Cadastro de Frota'),
      ),
      body: Padding(
        // Adiciona um padding ao corpo da tela.
        padding: const EdgeInsets.all(16.0),
        child: Form(
          // Define o formulário com a chave '_formKey'.
          key: _formKey,
          child: Column(
            children: [
              // Campo para a placa do veículo.
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
              // Campo para a marca do veículo.
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
              // Campo para o modelo do veículo.
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
              // Campo para a quilometragem do veículo.
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
              // Campo para o IMEI do rastreador.
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
              // Botão para salvar as informações do veículo.
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _saveVehicle();
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
