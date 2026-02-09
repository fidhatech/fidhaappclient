import 'dart:developer';
import 'package:dating_app/core/network/cubit/network_status_cubit.dart';
import 'package:dating_app/di/injection.dart';
import 'package:dating_app/features/employee/call/cubit/employee_call_cubit.dart';
import 'package:dating_app/features/employee/home/cubit/employee_cubit.dart';
import 'package:dating_app/features/employee/main/screen/main_screen.dart';
import 'package:dating_app/features/employee/service/employee_service.dart';
import 'package:dating_app/features/employee/session/cubit/employee_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeScope extends StatelessWidget {
  const EmployeeScope({super.key});

  @override
  Widget build(BuildContext context) {
    log("EmployeeScope: Building and providing EmployeeCubit");
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: sl<EmployeeSessionCubit>()..initialize(force: true),
        ),
        BlocProvider(
          create: (context) => EmployeeCubit(
            employeeService: sl<EmployeeService>(),
            sessionCubit: context.read<EmployeeSessionCubit>(),
            networkStatusCubit: context.read<NetworkStatusCubit>(),
          ),
        ),
        BlocProvider(create: (_) => sl<EmployeeCallCubit>()),
      ],
      child: const EmployeeMainScreen(),
    );
  }
}
