part of 'history_cubit.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object> get props => [];
}

final class HistoryInitial extends HistoryState {}

final class HistoryLoading extends HistoryState {}

final class HistoryLoaded extends HistoryState {
  final List<History> historyList;
  const HistoryLoaded(this.historyList);

  @override
  List<Object> get props => [historyList];
}

final class HistoryEmpty extends HistoryState {
  const HistoryEmpty();
}

final class HistoryError extends HistoryState {
  final String message;
  const HistoryError(this.message);

  @override
  List<Object> get props => [message];
}
