class Vehicle {
  final int? id;
  final String plateNumber;
  final String brand;
  final String model;
  final double mileage;
  final int? imei;

  Vehicle({
    this.id,
    required this.plateNumber,
    required this.brand,
    required this.model,
    required this.mileage,
    this.imei,
  });

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] as int?,
      plateNumber: map['plate_number'] as String? ?? '',
      brand: map['brand'] as String? ?? '',
      model: map['model'] as String? ?? '',
      mileage: (map['mileage'] as num?)?.toDouble() ?? 0.0,
      imei: map['imei'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'plate_number': plateNumber,
      'brand': brand,
      'model': model,
      'mileage': mileage,
      if (imei != null) 'imei': imei,
    };
  }
}
