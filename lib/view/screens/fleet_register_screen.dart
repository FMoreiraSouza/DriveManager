import 'package:drivemanager/presenter/controllers/fleet_register_controller.dart';
import 'package:drivemanager/core/utils/load_panel.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FleetRegisterScreen extends StatefulWidget {
  const FleetRegisterScreen({super.key});

  @override
  FleetRegisterScreenState createState() => FleetRegisterScreenState();
}

class FleetRegisterScreenState extends State<FleetRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late FleetRegisterController _controller;
  bool _isLoading = false;

  // FocusNodes para controle de foco
  final FocusNode _plateFocusNode = FocusNode();
  final FocusNode _brandFocusNode = FocusNode();
  final FocusNode _modelFocusNode = FocusNode();
  final FocusNode _mileageFocusNode = FocusNode();
  final FocusNode _trackerImeiFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final supabase = Supabase.instance.client;
    _controller = FleetRegisterController(supabase);
  }

  @override
  void dispose() {
    _plateFocusNode.dispose();
    _brandFocusNode.dispose();
    _modelFocusNode.dispose();
    _mileageFocusNode.dispose();
    _trackerImeiFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSaveVehicle() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _controller.saveVehicle();
      } catch (e) {
        // O erro já é tratado no controller, mas podemos mostrar um feedback adicional aqui se necessário
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar veículo: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Frota'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    focusNode: _plateFocusNode,
                    onChanged: _controller.setPlate,
                    onFieldSubmitted: (value) => _brandFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Placa'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a placa do veículo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    focusNode: _brandFocusNode,
                    onChanged: _controller.setBrand,
                    onFieldSubmitted: (value) => _modelFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Marca'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a marca do veículo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    focusNode: _modelFocusNode,
                    onChanged: _controller.setModel,
                    onFieldSubmitted: (value) => _mileageFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Modelo'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o modelo do veículo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    focusNode: _mileageFocusNode,
                    onChanged: _controller.setMileage,
                    onFieldSubmitted: (value) => _trackerImeiFocusNode.requestFocus(),
                    textInputAction: TextInputAction.next,
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
                  const SizedBox(height: 16.0),
                  TextFormField(
                    focusNode: _trackerImeiFocusNode,
                    onChanged: _controller.setTrackerImei,
                    onFieldSubmitted: (value) => _trackerImeiFocusNode.unfocus(),
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(labelText: 'IMEI do Rastreador'),
                    keyboardType: TextInputType.number,
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
                    onPressed: _isLoading ? null : _handleSaveVehicle,
                    child: const Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            const LoadPanel(
              label: 'Salvando veículo',
              bgColor: Colors.white,
            ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
