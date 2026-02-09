class WithdrawalRequestResponse {
  final bool success;
  final String message;

  WithdrawalRequestResponse({required this.success, required this.message});

  factory WithdrawalRequestResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawalRequestResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
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
    return WithdrawalHistoryItem(
      id: json['id']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      netAmount: (json['netAmount'] ?? 0).toDouble(),
      status: json['status'] ?? 'processing',
      requestedAt:
          DateTime.tryParse(json['createdAt'] ?? '') ??
          DateTime.now(), // Assuming 'createdAt' from API, falling back to now if missing
      utr: json['utr'],
      failureReason: json['failureReason'],
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'])
          : null,
    );
  }
}
