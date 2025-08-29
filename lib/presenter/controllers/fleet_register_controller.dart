import 'package:drivemanager/data/repository/vehicle_repository_impl.dart';
import 'package:drivemanager/domain/usecase/register_vehicle_usecase.dart';
import 'package:drivemanager/routes/navigation_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FleetRegisterController {
  final RegisterVehicleUsecase _registerVehicle;
  String _plate = '';
  String _brand = '';
  String _model = '';
  String _mileage = '';
  String _trackerImei = '';

  FleetRegisterController(SupabaseClient supabase)
      : _registerVehicle = RegisterVehicleUsecase(VehicleRepositoryImpl(supabase));

  void setPlate(String value) => _plate = value;
  void setBrand(String value) => _brand = value;
  void setModel(String value) => _model = value;
  void setMileage(String value) => _mileage = value;
  void setTrackerImei(String value) => _trackerImei = value;

  Future<void> saveVehicle() async {
    try {
      final mileage = double.tryParse(_mileage.replaceAll(',', '.')) ?? 0.0;

      if (_trackerImei.isEmpty) {
        NavigationService.showSnackBar('O IMEI não pode estar vazio.');
        return;
      }

      await _registerVehicle.execute(
        plateNumber: _plate,
        brand: _brand,
        model: _model,
        mileage: mileage,
        imei: _trackerImei,
      );

      NavigationService.showSnackBar('Veículo cadastrado com sucesso!');
      NavigationService.goBack(result: {
        'plate_number': _plate,
        'brand': _brand,
        'model': _model,
        'mileage': mileage,
        'imei': _trackerImei,
      });
    } catch (e) {
      NavigationService.showSnackBar('Erro ao salvar veículo: $e');
      rethrow;
    }
  }
}
