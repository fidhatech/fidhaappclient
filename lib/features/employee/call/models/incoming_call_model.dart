class IncomingCallModel {
  final String callId;
  final String roomId;
  final String callType; // "audio" or "video"
  final String callerId;
  final String callerName;

  IncomingCallModel({
    required this.callId,
    required this.roomId,
    required this.callType,
    required this.callerId,
    required this.callerName,
  });

  factory IncomingCallModel.fromJson(Map<String, dynamic> json) {
    return IncomingCallModel(
      callId: json['callId'] ?? '',
      roomId: json['roomId'] ?? '',
      callType: json['callType'] ?? 'audio',
      callerId: json['callerId'] ?? '',
      callerName: json['callerName'] ?? 'User',
    );
  }
}
