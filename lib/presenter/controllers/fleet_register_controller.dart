import 'package:flutter/material.dart';
import 'package:drivemanager/data/repository/vehicle_repository.dart';
import 'package:drivemanager/domain/usecase/register_vehicle.dart';
import 'package:drivemanager/routes/navigation_service.dart';

class FleetRegisterController {
  final RegisterVehicle _registerVehicle;
  final TextEditingController plateController;
  final TextEditingController brandController;
  final TextEditingController modelController;
  final TextEditingController mileageController;
  final TextEditingController trackerImeiController;

  FleetRegisterController(
    VehicleRepository vehicleRepository,
    this.plateController,
    this.brandController,
    this.modelController,
    this.mileageController,
    this.trackerImeiController,
  ) : _registerVehicle = RegisterVehicle(vehicleRepository);

  Future<void> saveVehicle() async {
    try {
      final mileage = double.tryParse(mileageController.text.replaceAll(',', '.')) ?? 0.0;
      final imei = int.tryParse(trackerImeiController.text);

      if (imei == null) {
        NavigationService.showSnackBar('O IMEI deve ser um número válido.');
        return;
      }

      await _registerVehicle.execute(
        plateNumber: plateController.text,
        brand: brandController.text,
        model: modelController.text,
        mileage: mileage,
        imei: imei,
      );

      NavigationService.goBack(result: {
        'plate_number': plateController.text,
        'brand': brandController.text,
        'model': modelController.text,
        'mileage': mileage,
        'imei': imei,
      });
    } catch (e) {
      NavigationService.showSnackBar('Erro ao salvar veículo: $e');
    }
  }
}
