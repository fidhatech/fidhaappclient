class CoinPackage {
  final String id;
  final int coins;
  final double actualPrice;
  final double offerPrice;

  CoinPackage({
    required this.id,
    required this.coins,
    required this.actualPrice,
    required this.offerPrice,
  });

  factory CoinPackage.fromJson(Map<String, dynamic> json) {
    return CoinPackage(
      id: json['_id'] ?? json['id'] ?? '',
      coins: json['coins'] ?? 0,
      actualPrice: (json['actualPrice'] ?? 0).toDouble(),
      offerPrice: (json['offerPrice'] ?? 0).toDouble(),
    );
  }
}
