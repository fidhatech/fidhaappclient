class PromotionModel {
  final String id;
  final String? packageId;
  final String title;
  final int coins;
  final int actualPrice;
  final int offerPrice;
  final DateTime date;
  final String type;

  PromotionModel({
    required this.id,
    this.packageId,
    required this.title,
    required this.coins,
    required this.actualPrice,
    required this.offerPrice,
    required this.date,
    required this.type,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'] ?? '',
      packageId: json['packageId'],
      title: json['title'] ?? '',
      coins: json['coins'] ?? 0,
      actualPrice: json['actualPrice'] ?? 0,
      offerPrice: json['offerPrice'] ?? 0,
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
      type: json['type'] ?? 'offer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packageId': packageId,
      'title': title,
      'coins': coins,
      'actualPrice': actualPrice,
      'offerPrice': offerPrice,
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  @override
  String toString() {
    return 'PromotionModel(id: $id, packageId: $packageId, title: $title, coins: $coins, actualPrice: $actualPrice, offerPrice: $offerPrice, type: $type)';
  }
}

class PromotionResponse {
  final bool success;
  final String message;
  final PromotionModel? promotion;

  PromotionResponse({
    required this.success,
    required this.message,
    this.promotion,
  });

  factory PromotionResponse.fromJson(Map<String, dynamic> json) {
    return PromotionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      promotion: json['promotion'] != null
          ? PromotionModel.fromJson(json['promotion'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'promotion': promotion?.toJson(),
    };
  }
}
