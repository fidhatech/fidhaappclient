import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating_app/core/network/socket/socket_service.dart';
import 'package:dating_app/features/user/features/home/models/home_update_response_model.dart';
import 'package:dating_app/features/user/features/premium/model/premium_response_model.dart';
import 'package:dating_app/features/user/features/premium/service/premium_service.dart';
import 'package:dating_app/features/user/models/employee_model.dart';
import 'package:dating_app/core/utils/error_mapper.dart';
import 'package:equatable/equatable.dart';

part 'premium_event.dart';
part 'premium_state.dart';

class PremiumBloc extends Bloc<PremiumEvent, PremiumState> {
  PremiumService premiumService;
  SocketService socketService;
  StreamSubscription? _statusSubscription;
  int _offset = 0;
  final List<EmployeeModel> _employees = [];
  PremiumBloc({required this.premiumService, required this.socketService})
    : super(PremiumInitial()) {
    on<FetchPremiumEvent>(_onFetchEvent);
    on<LoadMorePremium>(_onLoadMore);
    on<PremiumSocketStatusUpdate>(_onSocketStatus);
    _statusSubscription = socketService.statusStream.listen((data) {
      add(PremiumSocketStatusUpdate(data));
    });
    // socketService.on(SocketEvents.employeeStatusUpdate, (data) {
    //   final response = StatusUpdateModel.fromJson(data);
    //   add(PremiumSocketStatusUpdate(response));
    // });
  }
  Future<void> _onFetchEvent(
    FetchPremiumEvent event,
    Emitter<PremiumState> emit,
  ) async {
    emit(PremiumLoading());
    try {
      _offset = 0;
      _employees.clear();
      final response = await premiumService.fetchEmployee(
        limit: "20",
        offset: _offset.toString(),
      );
      _employees.addAll(response.employees);
      emit(
        PremiumLoaded(
          PremiumEmployeesResponse(
            employees: _employees,
            total: response.total,
            hasMore: response.hasMore,
          ),
        ),
      );
    } catch (e) {
      emit(PremiumError(mapError(e)));
    }
  }

  Future<void> _onLoadMore(
    LoadMorePremium event,
    Emitter<PremiumState> emit,
  ) async {
    if (state is! PremiumLoaded) return;
    final currentData = (state as PremiumLoaded).premiumEmployeesList;
    if (!currentData.hasMore) return;

    try {
      final response = await premiumService.fetchEmployee(
        limit: "20",
        offset: _offset.toString(),
      );

      _employees.addAll(response.employees);
      _offset = _employees.length;

      emit(
        PremiumLoaded(
          PremiumEmployeesResponse(
            employees: List.from(_employees),
            hasMore: response.hasMore,
            total: response.total,
          ),
        ),
      );
    } catch (e) {
      emit(PremiumLoaded(currentData));
    }
  }

  void _onSocketStatus(
    PremiumSocketStatusUpdate event,
    Emitter<PremiumState> emit,
  ) {
    if (state is! PremiumLoaded) return;
    final currentstate = state as PremiumLoaded;
    final index = _employees.indexWhere(
      (e) => e.empId == event.updateModel.employeeId,
    );
    if (index == -1) return;

    final current = _employees[index];
    if (!current.isPremium) return;
    _employees[index] = current.copyWith(status: event.updateModel.status);

    emit(
      PremiumLoaded(
        currentstate.premiumEmployeesList.copyWith(employees: _employees),
      ),
    );
  }

  @override
  Future<void> close() {
    _statusSubscription?.cancel();
    return super.close();
  }
}
