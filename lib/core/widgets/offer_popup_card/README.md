# Offer Popup Card Widget

A beautiful, customizable popup card widget for displaying promotional offers in your Flutter app.

## Features

- 🎨 Beautiful gradient background matching your app theme
- 🔥 Fire emoji icon and skip button
- 💰 Displays coins, original price (with strikethrough), and discounted price
- 🎁 Animated GIF support for gift box
- 💗 Decorative hearts
- 🎯 Fully customizable
- 📱 API-ready with PromotionModel support

## Files

- `offer_popup_card.dart` - Main widget
- `promotion_model.dart` - Data models for API integration
- `example_usage.dart` - Usage examples

## Usage

### Method 1: Using API Response Data

```dart
// Your API response
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
    "type": "offer"
  }
};

// Parse the response
final response = PromotionResponse.fromJson(jsonResponse);

// Show the popup
if (response.success && response.promotion != null) {
  OfferPopupCard.showFromPromotion(
    context,
    promotion: response.promotion!,
    onBuyNow: () {
      Navigator.of(context).pop();
      // Handle purchase logic
      print('Purchased ${response.promotion!.coins} coins');
    },
    onSkip: () {
      Navigator.of(context).pop();
    },
  );
}
```

### Method 2: Manual Values (Without API)

```dart
OfferPopupCard.show(
  context,
  title: 'Special Offer',
  coins: '567 coins',
  originalPrice: '\$300',
  discountedPrice: '\$199',
  buttonText: 'Buy Now @ 199',
  onBuyNow: () {
    Navigator.of(context).pop();
    // Handle purchase
  },
  onSkip: () {
    Navigator.of(context).pop();
  },
);
```

### Method 3: Using the Widget Directly

```dart
showDialog(
  context: context,
  builder: (context) => OfferPopupCard.fromPromotion(
    promotion: myPromotionModel,
    onBuyNow: () {
      // Handle purchase
    },
    onSkip: () {
      Navigator.of(context).pop();
    },
  ),
);
```

## API Response Format

The widget expects the following JSON structure:

```json
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
```

## Models

### PromotionModel

```dart
class PromotionModel {
  final String id;
  final String title;
  final int coins;
  final int actualPrice;
  final int offerPrice;
  final DateTime date;
  final String type;
}
```

### PromotionResponse

```dart
class PromotionResponse {
  final bool success;
  final String message;
  final PromotionModel? promotion;
}
```

## Customization

All parameters are optional with sensible defaults:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | String | 'Limited time offer' | Offer title |
| `coins` | String | '567 coins' | Coins amount |
| `originalPrice` | String | '\$300' | Original price (strikethrough) |
| `discountedPrice` | String | '\$199' | Discounted price |
| `buttonText` | String | 'Buy Now @ 199' | Button text |
| `onBuyNow` | VoidCallback? | null | Buy button callback |
| `onSkip` | VoidCallback? | null | Skip button callback |

## Assets Required

Make sure you have the gift box GIF in your assets:

```
assets/images/offer_card/offert_card_img.gif
```

Add it to your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/offer_card/offert_card_img.gif
```

## Design

The widget uses your app's existing color scheme from `AppColor`:
- Primary button color for the "Buy Now" button
- Secondary text color for the "Skip" button
- Text field border color for the card border
- Custom gradient background (dark purple theme)

## Example

See `example_usage.dart` for a complete working example with both API and manual usage.
