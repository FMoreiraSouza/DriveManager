class VehicleCoordinates {
  final String imei;
  final double latitude;
  final double longitude;
  final double speed;
  final bool isStopped;
  final DateTime timestamp;

  VehicleCoordinates({
    required this.imei,
    required this.latitude,
    required this.longitude,
    required this.speed,
    required this.isStopped,
    required this.timestamp,
  });

  factory VehicleCoordinates.fromMap(Map<String, dynamic> map) {
    return VehicleCoordinates(
      imei: map['imei'].toString(),
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      speed: (map['speed'] as num).toDouble(),
      isStopped: map['isStopped'] as bool,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }
}
