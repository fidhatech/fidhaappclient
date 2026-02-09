part of 'app_start_cubit.dart';

enum AppStartStatusState { initial, checking, determined }

class AppStartState extends Equatable {
  final AppStartStatusState status;
  final AppStartStatus? target;

  const AppStartState({required this.status, this.target});

  factory AppStartState.initial() =>
      const AppStartState(status: AppStartStatusState.initial);

  AppStartState copyWith({
    AppStartStatusState? status,
    AppStartStatus? target,
  }) {
    return AppStartState(
      status: status ?? this.status,
      target: target ?? this.target,
    );
  }

  @override
  List<Object?> get props => [status, target];
}
