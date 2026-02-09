class History {
  String callType;
  int duration;
  String time;
  String employeeName;
  List<String> employeeAvatar;
  String empId;

  History({
    required this.callType,
    required this.duration,
    required this.time,
    required this.employeeName,
    required this.employeeAvatar,
    required this.empId,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      callType: json['callType'],
      duration: json['duration'],
      time: json['time'],
      employeeName: json['employee']['name'],
      employeeAvatar: List<String>.from(json['employee']['avatar']),
      empId:
          json['employee']['_id'] ??
          json['employee']['id'] ??
          json['employee']['empId'] ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "callType": callType,
      "duration": duration,
      "time": time,
      "employee": {
        "name": employeeName,
        "avatar": employeeAvatar,
        "_id": empId,
      },
    };
  }
}
