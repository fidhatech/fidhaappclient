import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/core/network/socket/socket_service.dart';
import 'package:dating_app/core/services/socket_session_manager.dart';
import 'package:dating_app/core/storage/secure_storage.dart';
import 'package:dating_app/features/employee/constants/employee_constants.dart';
import 'package:dating_app/features/employee/service/employee_service.dart';
import 'package:dating_app/features/employee/session/cubit/employee_session_cubit.dart';
import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

part 'employee_account_state.dart';

class EmployeeAccountCubit extends Cubit<EmployeeAccountState> {
  final EmployeeService _employeeService;
  final GetIt sl = GetIt.instance;
  static const String _tag = '[${EmployeeConstants.featureName}] AccountCubit';

  EmployeeAccountCubit({required EmployeeService employeeService})
    : _employeeService = employeeService,
      super(EmployeeAccountInitial());

  Future<void> logout() async {
    log('$_tag Logout requested');
    if (isClosed) return;

    emit(LogoutLoading());
    try {
      await _employeeService.logout();
      log('$_tag API logout successful');

      await _performCleanup();

      if (!isClosed) emit(LogoutSuccess());
    } catch (e) {
      log('$_tag Logout API error: $e');
      // Even if API fails, we often want to cleanup locally
      await _performCleanup();
      if (!isClosed) emit(LogoutSuccess());
    }
  }

  Future<void> deleteAccount() async {
    log('$_tag Delete Account requested');
    if (isClosed) return;

    emit(DeleteAccountLoading());
    try {
      await _employeeService.deleteAccount();
      log('$_tag API delete successful');
      await _performCleanup();
      if (!isClosed) emit(DeleteAccountSuccess());
    } catch (e) {
      log('$_tag Delete API error: $e');
      if (!isClosed) emit(DeleteAccountFailure(e.toString()));
    }
  }

  Future<void> _performCleanup() async {
    log('$_tag 🧹 Starting cleanup process...');
    try {
      // 1. Disconnect Socket & Clear Tokens (Managed by SocketService + SecureStorage in logout implementation ideally)
      // But we double check here.
      if (sl.isRegistered<SocketSessionManager>()) {
        await sl<SocketSessionManager>().clearSession();
        log('$_tag 🧹 Socket session cleared.');
      } else if (sl.isRegistered<SocketService>()) {
        final socketService = sl<SocketService>();
        await socketService.disconnect(clear: true);
        log('$_tag 🧹 Socket disconnected and tokens cleared (fallback).');
      } else {
        await SecureStorage.clearTokens();
        log('$_tag 🧹 Tokens cleared manually (fallback).');
      }

      // 2. Reset Employee Session (Singleton)
      if (sl.isRegistered<EmployeeSessionCubit>()) {
        await sl<EmployeeSessionCubit>().cleanup();
        log('$_tag 🧹 EmployeeSessionCubit reset.');
      }

      // 3. User side cleanup (if shared app, might be needed, but prioritizing Employee)
      // If we are strictly Employee app, we might not need these.
      // Keeping them safe just in case.
      if (sl.isRegistered<UserCubit>()) {
        sl<UserCubit>().reset();
      }

      // 4. Cleanup Zego to avoid lifecycle assertions
      // await ZegoUIKit().uninit();
      // log('$_tag 🧹 Zego unitialized.');

      log('$_tag 🧹 Cleanup completed.');
    } catch (e) {
      log('$_tag ❌ Cleanup error: $e');
    }
  }
}
