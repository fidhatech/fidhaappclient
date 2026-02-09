import 'dart:developer';

import 'package:bloc/bloc.dart';

import 'package:dating_app/features/employee/session/cubit/employee_session_cubit.dart';

class EmployeeNavigatorCubit extends Cubit<int> {
  EmployeeSessionCubit employeeSessionCubit;

  EmployeeNavigatorCubit({required this.employeeSessionCubit}) : super(0);
  void changePage(int index) {
    if (state == index) return;
    emit(index);

    // If we return to the Home tab (0) and have a userId, ensure socket is connected
    if (index == 0) {
      log("Fetching employee home data at $index");
      // Home Screen's EmployeeCubit will handle data fetching on view.
    }
  }

  void reset() {
    emit(0);
  }
}
