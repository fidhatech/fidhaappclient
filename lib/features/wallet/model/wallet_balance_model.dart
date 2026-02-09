class WalletBalance {
  final int coins;
  final String message;

  WalletBalance({required this.coins, required this.message});

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      coins: json['coins'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
