import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drivemanager/presenter/routes/navigation_service.dart';

class FleetRegisterController {
  final SupabaseClient _supabase;
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

  Future<void> saveVehicle() async {
    try {
      final mileage = double.tryParse(mileageController.text.replaceAll(',', '.')) ?? 0.0;
      final imei = int.tryParse(trackerImeiController.text);

      if (imei == null) {
        NavigationService.showSnackBar('O IMEI deve ser um número válido.');
        return;
      }

      final newVehicle = {
        'plate_number': plateController.text,
        'brand': brandController.text,
        'model': modelController.text,
        'mileage': mileage,
        'imei': imei,
      };

      final response = await _supabase.from('vehicles').insert(newVehicle);

      if (response.error == null) {
        NavigationService.goBack(result: newVehicle);
      } else {
        NavigationService.showSnackBar('Erro ao salvar veículo: ${response.error!.message}');
      }
    } catch (e) {
      NavigationService.showSnackBar('Erro ao salvar veículo: $e');
    }
  }
}
