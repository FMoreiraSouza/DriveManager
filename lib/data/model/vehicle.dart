class Vehicle {
  final int? id;
  final String plateNumber;
  final String brand;
  final String model;
  final double mileage;
  final int? imei; // Alterado para int? para refletir bigint null

  Vehicle({
    this.id,
    required this.plateNumber,
    required this.brand,
    required this.model,
    required this.mileage,
    this.imei, // Agora aceita null
  });

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'] as int?,
      plateNumber: map['plate_number'] as String? ?? '',
      brand: map['brand'] as String? ?? '',
      model: map['model'] as String? ?? '',
      mileage: (map['mileage'] as num?)?.toDouble() ?? 0.0,
      imei: map['imei'] as int?, // Aceita int ou null diretamente
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'plate_number': plateNumber,
      'brand': brand,
      'model': model,
      'mileage': mileage,
      if (imei != null) 'imei': imei, // Lida com null
    };
  }

  Vehicle copyWith({
    int? id,
    String? plateNumber,
    String? brand,
    String? model,
    double? mileage,
    int? imei, // Alterado para int?
  }) {
    return Vehicle(
      id: id ?? this.id,
      plateNumber: plateNumber ?? this.plateNumber,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      mileage: mileage ?? this.mileage,
      imei: imei ?? this.imei,
    );
  }

  @override
  String toString() {
    return 'Vehicle(id: $id, plateNumber: $plateNumber, brand: $brand, model: $model, mileage: $mileage, imei: $imei)';
  }
}
