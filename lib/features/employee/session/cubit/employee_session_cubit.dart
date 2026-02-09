import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/core/network/socket/socket_service.dart';
import 'package:dating_app/core/services/socket_session_manager.dart';
import 'package:dating_app/core/utils/network_checker.dart';
import 'package:dating_app/features/employee/constants/employee_constants.dart';
import 'package:dating_app/features/employee/model/employee_model.dart';
import 'package:equatable/equatable.dart';

part 'employee_session_state.dart';

/// Session-level cubit that manages employee profile, earnings, and socket lifecycle.
class EmployeeSessionCubit extends Cubit<EmployeeSessionState> {
  final SocketService _socketService;
  final NetworkChecker _networkChecker;
  final SocketSessionManager _sessionManager;
  static const String _tag = '[${EmployeeConstants.featureName}] SessionCubit';

  EmployeeModel? _lastEmployeeModel;
  Timer? _debounce;
  bool _isInitialized = false;

  EmployeeSessionCubit(
    this._socketService,
    this._networkChecker,
    this._sessionManager,
  ) : super(EmployeeSessionInitial());

  Future<void> initialize({bool force = false}) async {
    if (isClosed) return;

    if (force) {
      log('$_tag 🔄 Force initialization requested. Resetting state.');
      _isInitialized = false;
    }

    if (!await _networkChecker.isConnected) {
      log('$_tag 🚫 initialize() - No Internet Connection');
      _isInitialized = false;
      safeEmit(EmployeeSessionOffline());
      return;
    }

    if (_isInitialized) {
      log('$_tag ⚠️ Already initialized. Refreshing session...');
      if (state is EmployeeSessionLoaded) {
        final userId = (state as EmployeeSessionLoaded).employee.id;
        if (userId.isNotEmpty) {
          _sessionManager.startSession(userId);
        }
      } else if (_lastEmployeeModel != null) {
        safeEmit(EmployeeSessionLoaded(employee: _lastEmployeeModel!));
        _sessionManager.startSession(_lastEmployeeModel!.id);
      }
      return;
    }

    log('$_tag 🚀 Session Initialized (Waiting for data from screens)');
    _isInitialized = true;
  }

  /// Called by EmployeeCubit to update global session data.
  void updateEmployeeData(EmployeeModel employee) {
    if (isClosed) return;

    log('$_tag 🔄 Updating session data for user: ${employee.id}');
    _lastEmployeeModel = employee;

    // Use SessionManager to enforce lifecycle rules on connection
    if (employee.id.isNotEmpty) {
      log('$_tag 🚀 Triggering Socket Session for ${employee.id}');
      _sessionManager.startSession(employee.id);
    } else {
      log('$_tag ⚠️ Employee ID is empty, skipping socket session start');
    }

    safeEmit(EmployeeSessionLoaded(employee: employee));
    _isInitialized = true;
  }

  /// Explicitly ensures socket is connected via Manager
  Future<void> ensureSocketConnected() async {
    if (isClosed) return;
    log('$_tag [SOCKET] Verifying socket state via SessionManager');
    _sessionManager.checkAndReconnect();
  }

  Future<void> cleanup() async {
    log('$_tag 🧹 Starting cleanup (Resetting Session)');
    _debounce?.cancel();

    // Clean disconnect via manager or service?
    // Manager has dispose() but we are just logging out, not disposing the singleton Manager.
    // So we just disconnect socket.
    await _socketService.disconnect();

    _lastEmployeeModel = null;
    _isInitialized = false;
    safeEmit(EmployeeSessionInitial());
    log('$_tag ✅ Session Reset complete');
  }

  void safeEmit(EmployeeSessionState newState) {
    if (!isClosed) {
      emit(newState);
    } else {
      log('$_tag ⚠️ Attempted to emit $newState after Cubit closed');
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
