import 'package:bloc/bloc.dart';
import 'package:dating_app/core/widgets/offer_popup_card/promotion_model.dart';
import 'package:dating_app/features/user/features/promotion/service/popup_offer_service.dart';
import 'package:equatable/equatable.dart';

abstract class PopupOfferState extends Equatable {
  const PopupOfferState();

  @override
  List<Object?> get props => [];
}

class PopupOfferInitial extends PopupOfferState {}

class PopupOfferLoading extends PopupOfferState {}

class PopupOfferLoaded extends PopupOfferState {
  final PromotionModel promotion;

  const PopupOfferLoaded(this.promotion);

  @override
  List<Object?> get props => [promotion];
}

class PopupOfferError extends PopupOfferState {
  final String message;

  const PopupOfferError(this.message);

  @override
  List<Object?> get props => [message];
}

class PopupOfferCubit extends Cubit<PopupOfferState> {
  final PopupOfferService _service;
  bool _hasFetched = false;

  PopupOfferCubit(this._service) : super(PopupOfferInitial());

  Future<void> checkAndFetchOffer() async {
    if (_hasFetched) {
      return;
    }

    emit(PopupOfferLoading());

    try {
      final response = await _service.fetchPopupOffer();
      if (response.success && response.promotion != null) {
        emit(PopupOfferLoaded(response.promotion!));
        _hasFetched = true;
      } else {
        emit(PopupOfferInitial());
      }
    } catch (e) {
      emit(PopupOfferError(e.toString()));
    }
  }

  void markAsShown() {
    _hasFetched = true;
  }
}
