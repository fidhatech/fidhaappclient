import 'package:bloc/bloc.dart';
import 'package:dating_app/core/app/app_start_decider.dart';
import 'package:equatable/equatable.dart';

part 'app_start_state.dart';

class AppStartCubit extends Cubit<AppStartState> {
  AppStartCubit() : super(AppStartState.initial());

  Future<void> checkAppStart() async {
    emit(state.copyWith(status: AppStartStatusState.checking));

    final decision = await AppStartDecider.determineStartStatus();

    emit(
      state.copyWith(status: AppStartStatusState.determined, target: decision),
    );
  }
}
