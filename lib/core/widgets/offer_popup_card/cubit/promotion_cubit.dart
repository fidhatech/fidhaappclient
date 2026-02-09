import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dating_app/core/widgets/offer_popup_card/promotion_model.dart';
import 'package:equatable/equatable.dart';

part 'promotion_state.dart';

class PromotionCubit extends Cubit<PromotionState> {
  PromotionCubit() : super(PromotionInitial());

  /// Fetch promotion data from server
  /// For now using mock data, replace with actual API call
  Future<void> fetchPromotion() async {
    emit(PromotionLoading());

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - replace with actual API call
      final mockPromotion = PromotionModel(
        id: "65b1f3c2e8f4a9a1c1234567",
        title: "New Year Offer",
        coins: 100,
        actualPrice: 199,
        offerPrice: 99,
        date: DateTime.parse("2026-01-05T10:30:00.000Z"),
        type: "offer",
      );

      log('Promotion fetched: ${mockPromotion.title}');
      emit(PromotionLoaded(mockPromotion));
    } catch (e) {
      log('Error fetching promotion: $e');
      emit(PromotionError(e.toString()));
    }
  }

  /// Load promotion from API response
  void loadPromotion(PromotionModel promotion) {
    emit(PromotionLoaded(promotion));
  }

  /// Clear promotion data
  void clearPromotion() {
    emit(PromotionEmpty());
  }

  /// Reset to initial state
  void reset() {
    if (!isClosed) {
      emit(PromotionInitial());
    }
  }
}
