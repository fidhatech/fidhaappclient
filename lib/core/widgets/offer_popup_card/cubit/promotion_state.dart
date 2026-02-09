part of 'promotion_cubit.dart';

abstract class PromotionState extends Equatable {
  const PromotionState();

  @override
  List<Object?> get props => [];
}

class PromotionInitial extends PromotionState {}

class PromotionLoading extends PromotionState {}

class PromotionLoaded extends PromotionState {
  final PromotionModel promotion;

  const PromotionLoaded(this.promotion);

  @override
  List<Object?> get props => [promotion];
}

class PromotionBuyingLoading extends PromotionState {}

class PromotionError extends PromotionState {
  final String message;

  const PromotionError(this.message);

  @override
  List<Object?> get props => [message];
}

class PromotionEmpty extends PromotionState {}
