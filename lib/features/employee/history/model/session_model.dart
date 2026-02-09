class SessionModel {
  final String id;
  final String callType;
  final String status;
  final int duration;
  final String? endReason;
  final DateTime time;
  final String userId;
  final String name;
  final String? avatar;

  SessionModel({
    required this.id,
    required this.callType,
    required this.status,
    required this.duration,
    this.endReason,
    required this.time,
    required this.userId,
    required this.name,
    this.avatar,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return SessionModel(
      id: json['id'] ?? '',
      callType: json['callType'] ?? '',
      status: json['status'] ?? '',
      duration: json['duration'] ?? 0,
      endReason: json['endReason'],
      time: DateTime.parse(json['time']),
      userId: user['id'] ?? '',
      name: user['name'] ?? '',
      avatar: user['avatar'],
    );
  }

  @override
  String toString() {
    return 'SessionModel(id: $id, callType: $callType, status: $status, duration: $duration, endReason: $endReason, time: $time, userId: $userId, name: $name, avatar: $avatar)';
  }
}
