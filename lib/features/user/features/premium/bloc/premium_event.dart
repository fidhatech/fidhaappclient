part of 'premium_bloc.dart';

sealed class PremiumEvent extends Equatable {
  const PremiumEvent();

  @override
  List<Object> get props => [];
}

class FetchPremiumEvent extends PremiumEvent {}

class LoadMorePremium extends PremiumEvent {}

class PremiumSocketStatusUpdate extends PremiumEvent {
  final StatusUpdateModel updateModel;
  const PremiumSocketStatusUpdate(this.updateModel);
}
