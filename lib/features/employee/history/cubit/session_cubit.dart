import 'package:bloc/bloc.dart';
import 'package:dating_app/features/employee/history/model/session_model.dart';
import 'package:dating_app/features/employee/history/service/session_history.dart';
import 'package:equatable/equatable.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final SessionHistory _service;
  SessionCubit(this._service) : super(SessionInitial());

  void fetch() async {
    emit(SessionLoading());
    try {
      final datas = await _service.fetchSession();
      emit(SessionLoaded(datas));
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }
}
