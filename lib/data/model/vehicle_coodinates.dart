class VehicleCoordinates {
  final int? id;
  final int? imei; // Alterado para int? para refletir bigint null
  final double latitude;
  final double longitude;
  final double speed;
  final bool isStopped;
  final DateTime timestamp;

  VehicleCoordinates({
    this.id,
    this.imei, // Agora aceita null
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.isStopped,
    required this.timestamp,
  });

  factory VehicleCoordinates.fromMap(Map<String, dynamic> map) {
    return VehicleCoordinates(
      id: map['id'] as int?,
      imei: map['imei'] as int?, // Aceita int ou null diretamente
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      speed: (map['speed'] as num?)?.toDouble() ?? 0.0,
      isStopped: map['isStopped'] as bool? ?? true,
      timestamp:
          map['timestamp'] != null ? DateTime.parse(map['timestamp'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (imei != null) 'imei': imei, // Lida com null
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'isStopped': isStopped,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  VehicleCoordinates copyWith({
    int? id,
    int? imei, // Alterado para int?
    double? latitude,
    double? longitude,
    double? speed,
    bool? isStopped,
    DateTime? timestamp,
  }) {
    return VehicleCoordinates(
      id: id ?? this.id,
      imei: imei ?? this.imei,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speed: speed ?? this.speed,
      isStopped: isStopped ?? this.isStopped,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'VehicleCoordinates(id: $id, imei: $imei, latitude: $latitude, longitude: $longitude, speed: $speed, isStopped: $isStopped, timestamp: $timestamp)';
  }
}
