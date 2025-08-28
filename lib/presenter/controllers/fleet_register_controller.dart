import 'package:drivemanager/data/repository/vehicle_repository_impl.dart';
import 'package:drivemanager/domain/usecase/register_vehicle.dart';
import 'package:drivemanager/routes/navigation_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FleetRegisterController {
  final RegisterVehicle _registerVehicle;
  String _plate = '';
  String _brand = '';
  String _model = '';
  String _mileage = '';
  String _trackerImei = '';

  FleetRegisterController(SupabaseClient supabase)
      : _registerVehicle = RegisterVehicle(VehicleRepositoryImpl(supabase));

  void setPlate(String value) => _plate = value;
  void setBrand(String value) => _brand = value;
  void setModel(String value) => _model = value;
  void setMileage(String value) => _mileage = value;
  void setTrackerImei(String value) => _trackerImei = value;

  Future<void> saveVehicle() async {
    try {
      final mileage = double.tryParse(_mileage.replaceAll(',', '.')) ?? 0.0;
      final imei = int.tryParse(_trackerImei);

      if (imei == null) {
        NavigationService.showSnackBar('O IMEI deve ser um número válido.');
        return;
      }

      await _registerVehicle.execute(
        plateNumber: _plate,
        brand: _brand,
        model: _model,
        mileage: mileage,
        imei: imei,
      );

      NavigationService.goBack(result: {
        'plate_number': _plate,
        'brand': _brand,
        'model': _model,
        'mileage': mileage,
        'imei': imei,
      });
    } catch (e) {
      NavigationService.showSnackBar('Erro ao salvar veículo: $e');
      rethrow; // Re-lança a exceção para que a screen saiba que houve erro
    }
  }
}
