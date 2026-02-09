class CallData {
  String callId;
  String roomId;
  String status;
  CallData(this.callId, this.roomId, this.status);
  factory CallData.fromJson(Map<String, dynamic> json) {
    return CallData(json["callId"], json["roomId"], json["status"]);
  }
}
