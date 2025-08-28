class Notification {
  final int? id;
  final String? plateNumber; // Alterado para String? para refletir text null
  final String message;
  final DateTime timestamp;
  final bool isRead;

  Notification({
    this.id,
    this.plateNumber, // Agora aceita null
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      id: map['id'] as int?,
      plateNumber: map['plate_number'] as String?, // Aceita null
      message: map['message'] as String? ?? '',
      timestamp:
          map['timestamp'] != null ? DateTime.parse(map['timestamp'] as String) : DateTime.now(),
      isRead: map['is_read'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      if (plateNumber != null) 'plate_number': plateNumber, // Lida com null
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }

  Notification copyWith({
    int? id,
    String? plateNumber,
    String? message,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return Notification(
      id: id ?? this.id,
      plateNumber: plateNumber ?? this.plateNumber,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  String toString() {
    return 'Notification(id: $id, plateNumber: $plateNumber, message: $message, timestamp: $timestamp, isRead: $isRead)';
  }
}
