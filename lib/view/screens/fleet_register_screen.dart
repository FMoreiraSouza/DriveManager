import 'package:drivemanager/presenter/controllers/fleet_register_controller.dart';
import 'package:drivemanager/core/utils/load_panel.dart';
import 'package:drivemanager/view/widgets/fleet_register_form_widget.dart';
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
      setState(() => _isLoading = true);
      try {
        await _controller.saveVehicle();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao salvar veículo: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
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
            child: FleetRegisterForm(
              formKey: _formKey,
              onPlateChanged: _controller.setPlate,
              onBrandChanged: _controller.setBrand,
              onModelChanged: _controller.setModel,
              onMileageChanged: _controller.setMileage,
              onTrackerImeiChanged: _controller.setTrackerImei,
              plateFocusNode: _plateFocusNode,
              brandFocusNode: _brandFocusNode,
              modelFocusNode: _modelFocusNode,
              mileageFocusNode: _mileageFocusNode,
              trackerImeiFocusNode: _trackerImeiFocusNode,
              onSave: _handleSaveVehicle,
              isLoading: _isLoading,
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
