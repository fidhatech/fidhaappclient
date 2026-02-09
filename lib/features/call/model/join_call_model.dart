class JoinCallModel {
  final int appId;
  final String token;
  final String roomId;
  final String callType;

  JoinCallModel({
    required this.appId,
    required this.token,
    required this.roomId,
    required this.callType,
  });

  factory JoinCallModel.fromJson(Map<String, dynamic> json) {
    return JoinCallModel(
      appId: json['appId'] ?? 0,
      token: json['token'] ?? '',
      roomId: json['roomId'] ?? '',
      callType: json['callType'] ?? 'audio',
    );
  }
}
