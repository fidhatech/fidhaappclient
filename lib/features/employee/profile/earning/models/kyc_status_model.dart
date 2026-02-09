class EmployeeKycStatusModel {
  final bool hasKYC;
  final bool isCompleted;
  final bool panVerified;
  final bool upiVerified;
  final String? panHolderName;
  final String? upiId;

  EmployeeKycStatusModel({
    required this.hasKYC,
    required this.isCompleted,
    required this.panVerified,
    required this.upiVerified,
    this.panHolderName,
    this.upiId,
  });

  factory EmployeeKycStatusModel.fromJson(Map<String, dynamic> json) {
    return EmployeeKycStatusModel(
      hasKYC: json['hasKYC'] ?? false,
      isCompleted: json['isCompleted'] ?? false,
      panVerified: json['panVerified'] ?? false,
      upiVerified: json['upiVerified'] ?? false,
      panHolderName: json['panHolderName'],
      upiId: json['upiId'],
    );
  }

  factory EmployeeKycStatusModel.empty() {
    return EmployeeKycStatusModel(
      hasKYC: false,
      isCompleted: false,
      panVerified: false,
      upiVerified: false,
    );
  }
}
