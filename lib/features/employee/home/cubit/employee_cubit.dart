import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/core/network/cubit/network_status_cubit.dart';
import 'package:dating_app/features/employee/constants/employee_constants.dart';
import 'package:dating_app/features/employee/model/employee_model.dart';
import 'package:dating_app/features/employee/service/employee_service.dart';
import 'package:dating_app/features/employee/session/cubit/employee_session_cubit.dart';
import 'package:equatable/equatable.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  final EmployeeService _employeeService;
  final EmployeeSessionCubit _sessionCubit;
  Timer? _debounce;
  static const String _tag = '[${EmployeeConstants.featureName}] EmployeeCubit';

  StreamSubscription? _networkSubscription;

  EmployeeCubit({
    required EmployeeService employeeService,
    required EmployeeSessionCubit sessionCubit,
    required NetworkStatusCubit networkStatusCubit,
  }) : _employeeService = employeeService,
       _sessionCubit = sessionCubit,
       _networkStatusCubit = networkStatusCubit,
       super(EmployeeInitial()) {
    log('$_tag 🛠️ Created');
    _monitorNetwork();
  }

  final NetworkStatusCubit _networkStatusCubit;

  void _monitorNetwork() {
    _networkSubscription = _networkStatusCubit.stream.listen((networkState) {
      if (networkState.status == NetworkStatus.online) {
        if (state is EmployeeOffline ||
            state is EmployeeInitial ||
            state is EmployeeFailure) {
          log('$_tag 🌐 Network restored. explicit retry requested...');
          retry();
        }
      }
    });
  }

  /// Explicit retry entry point for UI and Auto-Recovery
  void retry() {
    if (isClosed) return;

    // Retry Condition 1: Must be online
    if (_networkStatusCubit.state.status != NetworkStatus.online) {
      log('$_tag ⚠️ Retry ignored: Still offline');
      return;
    }

    // Retry Condition 2: Prevent redundant reloads if already successful
    if (state is EmployeeSuccess) {
      log('$_tag ⚠️ Retry ignored: Already loaded');
      return;
    }

    log('$_tag 🔄 Retry requested from state: $state');

    // Clear error state by moving to loading
    safeEmit(EmployeeLoading());
    loadHomeData();
  }

  /// Explicitly load home data. Called from EmployeeHomeScreen.
  Future<void> loadHomeData() async {
    if (isClosed) return;

    // 🛑 Network Guard
    if (_networkStatusCubit.state.status == NetworkStatus.offline) {
      log(
        '$_tag 🛑 [GUARD] Offline detected. Blocking feature initialization.',
      );
      safeEmit(EmployeeOffline());
      return;
    }

    safeEmit(EmployeeLoading());
    log('$_tag 🏠 Loading home data...');

    try {
      final prevState = state;
      // ✅ Use new optimized service method
      final mergedEmployee = await _employeeService.fetchFullEmployeeData();

      if (isClosed) return;

      log('$_tag 🏠 Home data available: ${mergedEmployee.id}');
      log(
        '$_tag 🏠 State Transition: ${prevState.runtimeType} -> EmployeeSuccess',
      );

      // Update local state and Sync with Session
      safeEmit(EmployeeSuccess(employee: mergedEmployee));
      _sessionCubit.updateEmployeeData(mergedEmployee);
    } catch (e) {
      log('$_tag ❌ Error loading home data: $e');
      // If we have connection issues:
      if (e.toString().toLowerCase().contains('socket') ||
          e.toString().toLowerCase().contains('connection') ||
          e.toString().toLowerCase().contains('failed host lookup')) {
        safeEmit(EmployeeOffline());
        log('$_tag ⚠️ Marking as Offline');
      } else {
        safeEmit(EmployeeFailure(message: e.toString()));
      }
    }
  }

  void reset() {
    log('$_tag 🧹 Resetting state');
    _debounce?.cancel();
    _networkSubscription?.cancel();
    safeEmit(EmployeeInitial());
  }

  Future<void> updateCallPreference({
    bool? isAudioEnabled,
    bool? isVideoEnabled,
  }) async {
    if (isClosed) return;

    final currentState = state;
    if (currentState is! EmployeeSuccess) {
      log('$_tag ⚠️ updateCallPreference ignored: Not in Success state');
      return;
    }

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Optimistic Update
    final updatedEmployee = currentState.employee.copyWith(
      isAudioEnabled: isAudioEnabled ?? currentState.employee.isAudioEnabled,
      isVideoEnabled: isVideoEnabled ?? currentState.employee.isVideoEnabled,
    );

    safeEmit(EmployeeSuccess(employee: updatedEmployee));
    // Also sync session immediately for fast UI feedback elsewhere if needed
    _sessionCubit.updateEmployeeData(updatedEmployee);

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        await _employeeService.updateCallPreference(
          isAudioEnabled: isAudioEnabled,
          isVideoEnabled: isVideoEnabled,
        );
        log('$_tag ✅ Call preference API success');
      } catch (e) {
        log('$_tag ❌ Call preference API failed: $e');
        if (!isClosed) {
          // Revert
          safeEmit(currentState);
          _sessionCubit.updateEmployeeData(currentState.employee);
        }
      }
    });
  }

  void safeEmit(EmployeeState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
