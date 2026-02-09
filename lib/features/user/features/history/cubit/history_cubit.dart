import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/features/user/features/history/model/history_model.dart';
import 'package:dating_app/features/user/features/history/service/history_service.dart';
import 'package:equatable/equatable.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryService _historyService;
  HistoryCubit(this._historyService) : super(HistoryInitial());

  void fetch() async {
    emit(HistoryLoading());
    log('History: Loading state emitted');
    try {
      final data = await _historyService.fetchHistory();
      log('History: Received ${data.length} items');
      if (data.isEmpty) {
        log('History: Empty state emitted');
        emit(HistoryEmpty());
      } else {
        log('History: Loaded state emitted with ${data.length} items');
        emit(HistoryLoaded(data));
      }
    } catch (e) {
      log('History Error: $e');
      emit(HistoryError(e.toString()));
    }
  }
}
