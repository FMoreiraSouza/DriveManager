class Vehicle {
  final int id;
  final String plateNumber;
  final String brand;
  final String model;
  final double mileage;
  final String imei;
  final bool hasDefect;

  Vehicle({
    required this.id,
    required this.plateNumber,
    required this.brand,
    required this.model,
    required this.mileage,
    required this.imei,
    this.hasDefect = false,
  });

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] as int,
      plateNumber: map['plate_number'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      mileage: (map['mileage'] as num).toDouble(),
      imei: map['imei'].toString(),
      hasDefect: map['hasDefect'] as bool,
    );
  }
}
