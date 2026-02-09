import 'package:flutter/material.dart';
import 'package:dating_app/core/widgets/offer_popup_card/offer_popup_card.dart';
import 'package:dating_app/core/widgets/offer_popup_card/promotion_model.dart';

/// Example usage of OfferPopupCard
///
/// METHOD 1: Using API Response Data
///
/// ```dart
/// // Parse the API response
/// final jsonResponse = {
///   "success": true,
///   "message": "Popup offer fetched successfully",
///   "promotion": {
///     "id": "65b1f3c2e8f4a9a1c1234567",
///     "title": "New Year Offer",
///     "coins": 100,
///     "actualPrice": 199,
///     "offerPrice": 99,
///     "date": "2026-01-05T10:30:00.000Z",
///     "type": "offer"
///   }
/// };
///
/// final response = PromotionResponse.fromJson(jsonResponse);
///
/// if (response.success && response.promotion != null) {
///   OfferPopupCard.showFromPromotion(
///     context,
///     promotion: response.promotion!,
///     onBuyNow: () {
///       Navigator.of(context).pop();
///       // Handle purchase logic here
///       print('User bought ${response.promotion!.coins} coins for \$${response.promotion!.offerPrice}');
///     },
///     onSkip: () {
///       Navigator.of(context).pop();
///       print('User skipped the offer');
///     },
///   );
/// }
/// ```
///
/// METHOD 2: Manual values (without API)
///
/// ```dart
/// OfferPopupCard.show(
///   context,
///   title: 'Special Offer',
///   coins: '567 coins',
///   originalPrice: '\$300',
///   discountedPrice: '\$199',
///   buttonText: 'Buy Now @ 199',
///   onBuyNow: () {
///     Navigator.of(context).pop();
///     // Handle purchase logic here
///   },
///   onSkip: () {
///     Navigator.of(context).pop();
///   },
/// );
/// ```

class OfferPopupExample extends StatelessWidget {
  const OfferPopupExample({super.key});

  // Simulated API response
  final String mockApiResponse = '''
  {
    "success": true,
    "message": "Popup offer fetched successfully",
    "promotion": {
      "id": "65b1f3c2e8f4a9a1c1234567",
      "title": "New Year Offer",
      "coins": 100,
      "actualPrice": 199,
      "offerPrice": 99,
      "date": "2026-01-05T10:30:00.000Z",
      "type": "offer"
    }
  }
  ''';

  void _showOfferFromApi(BuildContext context) {
    // In real app, you would fetch this from your API
    final jsonResponse = {
      "success": true,
      "message": "Popup offer fetched successfully",
      "promotion": {
        "id": "65b1f3c2e8f4a9a1c1234567",
        "title": "New Year Offer",
        "coins": 100,
        "actualPrice": 199,
        "offerPrice": 99,
        "date": "2026-01-05T10:30:00.000Z",
        "type": "offer",
      },
    };

    final response = PromotionResponse.fromJson(jsonResponse);

    if (response.success && response.promotion != null) {
      OfferPopupCard.showFromPromotion(
        context,
        promotion: response.promotion!,
        onBuyNow: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Purchased ${response.promotion!.coins} coins for \$${response.promotion!.offerPrice}!',
              ),
            ),
          );
        },
        onSkip: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Offer skipped')));
        },
      );
    }
  }

  void _showOfferManually(BuildContext context) {
    OfferPopupCard.show(
      context,
      title: 'Limited time offer',
      coins: '567 coins',
      originalPrice: '\$300',
      discountedPrice: '\$199',
      buttonText: 'Buy Now @ 199',
      onBuyNow: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Purchase initiated!')));
      },
      onSkip: () {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Offer skipped')));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offer Popup Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showOfferFromApi(context),
              child: const Text('Show Offer (From API)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showOfferManually(context),
              child: const Text('Show Offer (Manual)'),
            ),
          ],
        ),
      ),
    );
  }
}
