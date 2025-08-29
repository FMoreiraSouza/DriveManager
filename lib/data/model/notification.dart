class Notification {
  final int? id;
  final String? plateNumber;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  Notification({
    this.id,
    this.plateNumber,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] as int?,
      plateNumber: map['plate_number'] as String?,
      message: map['message'] as String? ?? '',
      timestamp:
          map['timestamp'] != null ? DateTime.parse(map['timestamp'] as String) : DateTime.now(),
      isRead: map['is_read'] as bool? ?? false,
    );
  }
}
