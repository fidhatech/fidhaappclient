import 'dart:developer';

import 'package:dating_app/core/services/firebase_notification_service.dart';
import 'package:dating_app/features/employee/employee_home/screen/employee_home_screen.dart';
import 'package:dating_app/features/employee/employee_home/widgets/employee_call_listener.dart';
import 'package:dating_app/features/employee/home/cubit/employee_cubit.dart';
import 'package:dating_app/features/employee/session/cubit/employee_session_cubit.dart';
import 'package:dating_app/features/employee/home/screens/offline_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeHomeWrapper extends StatefulWidget {
  const EmployeeHomeWrapper({super.key});

  @override
  State<EmployeeHomeWrapper> createState() => _EmployeeHomeWrapperState();
}

class _EmployeeHomeWrapperState extends State<EmployeeHomeWrapper> {
  @override
  void initState() {
    super.initState();
    log("EmployeeHomeWrapper: initState called");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("EmployeeHomeWrapper: checking permissions...");
      FirebaseNotificationService.checkAndRequestPermission(context);
    });

    // Trigger initial data load
    context.read<EmployeeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeSessionCubit, EmployeeSessionState>(
      builder: (context, state) {
        if (state is EmployeeSessionOffline) {
          return const EmployeeOfflineScreen();
        }
        return const EmployeeCallListener(child: EmployeeHomeScreen());
      },
    );
  }
}
