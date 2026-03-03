class BankAccountModel {
  final bool hasBankDetails;
  final bool isVerified;
  final String? accountHolderName;
  final String? bankName;
  final String? accountNumber;
  final String? ifscCode;

  BankAccountModel({
    required this.hasBankDetails,
    required this.isVerified,
    this.accountHolderName,
    this.bankName,
    this.accountNumber,
    this.ifscCode,
  });

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(
      hasBankDetails: json['hasBankDetails'] ?? false,
      isVerified: json['isVerified'] ?? false,
      accountHolderName: json['accountHolderName'],
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      ifscCode: json['ifscCode'],
    );
  }

  factory BankAccountModel.empty() {
    return BankAccountModel(hasBankDetails: false, isVerified: false);
  }

  Map<String, dynamic> toJson() {
    return {
      'hasBankDetails': hasBankDetails,
      'isVerified': isVerified,
      'accountHolderName': accountHolderName,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
    };
  }
}
