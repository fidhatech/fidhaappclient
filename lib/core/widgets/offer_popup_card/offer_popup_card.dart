import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/widgets/offer_popup_card/promotion_model.dart';

class OfferPopupCard extends StatelessWidget {
  final Function()? onBuyNow;
  final VoidCallback? onSkip;
  final String title;
  final String coins;
  final String originalPrice;
  final String discountedPrice;
  final String buttonText;

  const OfferPopupCard({
    super.key,
    this.onBuyNow,
    this.onSkip,
    this.title = 'Limited time offer',
    this.coins = '567 coins',
    this.originalPrice = '\$300',
    this.discountedPrice = '\$199',
    this.buttonText = 'Buy Now @ 199',
  });

  /// Create OfferPopupCard from PromotionModel
  factory OfferPopupCard.fromPromotion({
    required PromotionModel promotion,
    Function()? onBuyNow,
    VoidCallback? onSkip,
  }) {
    return OfferPopupCard(
      title: promotion.title,
      coins: '${promotion.coins} coins',
      originalPrice: '₹${promotion.actualPrice}',
      discountedPrice: '₹${promotion.offerPrice}',
      buttonText: 'Buy Now @ ${promotion.offerPrice}',
      onBuyNow: onBuyNow,
      onSkip: onSkip,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Local state for loading using ValueNotifier in StatelessWidget
    final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(isCompact ? 16 : 24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2D1B3D), Color(0xFF1A0F28)],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColor.textFieldBorder.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with fire icon and skip button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '🔥',
                        style: TextStyle(fontSize: isCompact ? 26 : 32),
                      ),
                      GestureDetector(
                        onTap: onSkip,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: AppColor.secondaryText,
                            fontSize: isCompact ? 14 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isCompact ? 12 : 16),

                  // Title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: const TextStyle(
                      color: Color(0xFFD8A7E8),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isCompact ? 16 : 24),

                  // Content row with text and gift image
                  if (isCompact)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left side - coins and price
                        Column(
                          children: [
                            Text(
                              coins,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                Text(
                                  originalPrice,
                                  style: TextStyle(
                                    color: AppColor.secondaryText,
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: AppColor.secondaryText,
                                    decorationThickness: 2,
                                  ),
                                ),
                                Text(
                                  discountedPrice,
                                  style: const TextStyle(
                                    color: Color(0xFFE65ACF),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Right side - gift box image
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/images/offer_card/offert_card_img.gif',
                                width: 98,
                                height: 98,
                                fit: BoxFit.contain,
                              ),
                              const Positioned(
                                top: 8,
                                right: 18,
                                child: Text(
                                  '💗',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              const Positioned(
                                top: 26,
                                right: 8,
                                child: Text(
                                  '💗',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left side - coins and price
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Coins text
                              Text(
                                coins,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Price row
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Original price (strikethrough)
                                  Text(
                                    originalPrice,
                                    style: TextStyle(
                                      color: AppColor.secondaryText,
                                      fontSize: 16,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: AppColor.secondaryText,
                                      decorationThickness: 2,
                                    ),
                                  ),
                                  const SizedBox(width: 6),

                                  // Discounted price
                                  Text(
                                    discountedPrice,
                                    style: const TextStyle(
                                      color: Color(0xFFE65ACF),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Right side - gift box image
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Gift box GIF
                              Image.asset(
                                'assets/images/offer_card/offert_card_img.gif',
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),

                              // Decorative hearts
                              Positioned(
                                top: 10,
                                right: 20,
                                child: Text(
                                  '💗',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                              Positioned(
                                top: 30,
                                right: 10,
                                child: Text(
                                  '💗',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: isCompact ? 18 : 32),

                  // Buy Now button
                  SizedBox(
                    width: double.infinity,
                    height: isCompact ? 50 : 56,
                    child: ValueListenableBuilder<bool>(
                      valueListenable: isLoading,
                      builder: (context, loading, child) {
                        return ElevatedButton(
                          onPressed: loading
                              ? null
                              : () async {
                                  isLoading.value = true;
                                  try {
                                    final result = onBuyNow?.call();
                                    if (result is Future) {
                                      await result;
                                    }
                                  } finally {
                                    // Check if we can safely update state.
                                    // In stateless widget with ValueNotifier, we just update the value.
                                    // If widget is unmounted, builder wont rebuild.
                                    isLoading.value = false;
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.primaryButton,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 0,
                          ),
                          child: loading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  buttonText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: isCompact ? 15 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Show the offer popup dialog
  static Future<void> show(
    BuildContext context, {
    Function()? onBuyNow,
    VoidCallback? onSkip,
    String? title,
    String? coins,
    String? originalPrice,
    String? discountedPrice,
    String? buttonText,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => OfferPopupCard(
        onBuyNow: onBuyNow ?? () => Navigator.of(context).pop(),
        onSkip: onSkip ?? () => Navigator.of(context).pop(),
        title: title ?? 'Limited time offer',
        coins: coins ?? '567 coins',
        originalPrice: originalPrice ?? '\$300',
        discountedPrice: discountedPrice ?? '\$199',
        buttonText: buttonText ?? 'Buy Now @ 199',
      ),
    );
  }

  /// Show the offer popup dialog from PromotionModel
  static Future<void> showFromPromotion(
    BuildContext context, {
    required PromotionModel promotion,
    Function()? onBuyNow,
    VoidCallback? onSkip,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => OfferPopupCard.fromPromotion(
        promotion: promotion,
        onBuyNow: onBuyNow ?? () => Navigator.of(context).pop(),
        onSkip: onSkip ?? () => Navigator.of(context).pop(),
      ),
    );
  }
}
