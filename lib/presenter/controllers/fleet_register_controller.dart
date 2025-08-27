import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drivemanager/presenter/routes/navigation_service.dart';

class FleetRegisterController {
  final SupabaseClient _supabase;

  // Controladores para obtenção de informações no input do usuário gestor
  final TextEditingController plateController;
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController mileageController;
  final TextEditingController trackerImeiController;

  FleetRegisterController(
    this._supabase,
    this.plateController,
    this.brandController,
    this.modelController,
    this.mileageController,
    this.trackerImeiController,
  );

  // Função para salvar um novo veículo
  Future<void> saveVehicle() async {
    final newVehicle = {
      'plate_number': plateController.text,
      'brand': brandController.text,
      'model': modelController.text,
      'mileage': mileageController.text,
      'imei': trackerImeiController.text,
    };

    final response = await _supabase.from('vehicles').insert(newVehicle);

    if (response == null) {
      NavigationService.goBack(result: newVehicle);
    } else {
      NavigationService.showSnackBar('Erro ao salvar veículo: ${response.error!.message}');
    }
  }
}
