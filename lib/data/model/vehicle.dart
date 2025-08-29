class Vehicle {
  final int id;
  final String plateNumber;
  final String brand;
  final String model;
  final double mileage;
  final String imei;

  Vehicle({
    required this.id,
    required this.plateNumber,
    required this.brand,
    required this.model,
    required this.mileage,
    required this.imei,
  });

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] as int,
      plateNumber: map['plate_number'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      mileage: (map['mileage'] as num).toDouble(),
      imei: map['imei'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plate_number': plateNumber,
      'brand': brand,
      'model': model,
      'mileage': mileage,
      'imei': imei,
    };
  }

  @override
  String toString() {
    return 'Vehicle{id: $id, plateNumber: $plateNumber, brand: $brand, model: $model, mileage: $mileage, imei: $imei}';
  }
}
