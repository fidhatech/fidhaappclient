class JoinCallModel {
  final int appId;
  final String token;
  final String roomId;
  final String callType;
  final int? maxDurationSeconds;

  JoinCallModel({
    required this.appId,
    required this.token,
    required this.roomId,
    required this.callType,
    this.maxDurationSeconds,
  });

  factory JoinCallModel.fromJson(Map<String, dynamic> json) {
    return JoinCallModel(
      appId: json['appId'] ?? 0,
      token: json['token'] ?? '',
      roomId: json['roomId'] ?? '',
      callType: json['callType'] ?? 'audio',
      maxDurationSeconds: json['maxDurationSeconds'] is int
          ? json['maxDurationSeconds'] as int
          : int.tryParse('${json['maxDurationSeconds'] ?? ''}'),
    );
  }
}
