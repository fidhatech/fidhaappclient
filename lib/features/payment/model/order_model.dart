class RazorpayOrderModel {
  final String orderId;
  final int amount;
  final String currency;
  final String razorpayKeyId;
  final int coins;

  RazorpayOrderModel({
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.razorpayKeyId,
    required this.coins,
  });

  factory RazorpayOrderModel.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderModel(
      orderId: json['orderId'],
      amount: json['amount'],
      currency: json['currency'],
      razorpayKeyId: json['razorpayKeyId'],
      coins: json['coins'],
    );
  }
}
