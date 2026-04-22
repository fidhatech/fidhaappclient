class WithdrawalRequestResponse {
  final bool success;
  final String message;
  final String? withdrawalId;
  final String? status;
  final double? netAmount;
  final double? platformFee;

  WithdrawalRequestResponse({
    required this.success,
    required this.message,
    this.withdrawalId,
    this.status,
    this.netAmount,
    this.platformFee,
  });

  factory WithdrawalRequestResponse.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : null;

    return WithdrawalRequestResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      withdrawalId: data?['withdrawalId']?.toString(),
      status: data?['status']?.toString(),
      netAmount: (data?['netAmount'] as num?)?.toDouble(),
      platformFee: (data?['platformFee'] as num?)?.toDouble(),
    );
  }
}

class WithdrawalHistoryItem {
  final String id;
  final double amount;
  final double netAmount;
  final String status; // 'processing', 'completed', 'failed'
  final DateTime requestedAt;
  final String? utr;
  final String? failureReason;
  final DateTime? completedAt;

  WithdrawalHistoryItem({
    required this.id,
    required this.amount,
    required this.netAmount,
    required this.status,
    required this.requestedAt,
    this.utr,
    this.failureReason,
    this.completedAt,
  });

  factory WithdrawalHistoryItem.fromJson(Map<String, dynamic> json) {
    final requestedAtRaw =
        json['requestedAt'] ?? json['createdAt'] ?? json['updatedAt'];

    return WithdrawalHistoryItem(
      id: json['id']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      netAmount: (json['netAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'processing',
      requestedAt:
          DateTime.tryParse(requestedAtRaw?.toString() ?? '') ?? DateTime.now(),
      utr: json['utr'],
      failureReason: json['failureReason'],
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'].toString())
          : null,
    );
  }
}
