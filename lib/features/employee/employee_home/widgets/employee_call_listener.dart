import 'dart:developer';

import 'package:dating_app/features/call/call_permission_service.dart';
import 'package:dating_app/features/call/incoming_call/screen/incoming_call_screen.dart';
import 'package:dating_app/features/call/screens/call_ui_kit.dart';
import 'package:dating_app/features/employee/call/cubit/employee_call_cubit.dart';
import 'package:dating_app/features/employee/home/cubit/employee_cubit.dart';
import 'package:dating_app/features/user/features/call/model/call_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeCallListener extends StatelessWidget {
  final Widget child;

  const EmployeeCallListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCallCubit, EmployeeCallState>(
      listener: (context, state) {
        if (state is CallRinging) {
          final cubit = context.read<EmployeeCallCubit>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: IncomingCallScreen(
                  callerName: state.callModel.callerName,
                  callId: state.callModel.callId,
                ),
              ),
            ),
          );
        } else if (state is CallRejecting) {
          if (Navigator.canPop(context)) Navigator.pop(context);
        } else if (state is CallAccepting) {
          if (Navigator.canPop(context)) Navigator.pop(context);
        } else if (state is CallJoining) {
          if (Navigator.canPop(context)) Navigator.pop(context);

          CallPermissionService.requestCallPermissions(context).then((granted) {
            if (!context.mounted) return;
            if (granted) {
              final employeeState = context.read<EmployeeCubit>().state;
              String currentUserId = '';
              String currentUserName = 'Employee';

              if (employeeState is EmployeeSuccess) {
                currentUserId = employeeState.employee.id;
                currentUserName = employeeState.employee.name;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CallUiKit(
                    appId: state.joinData.appId,
                    callId: state.joinData.roomId,
                    token: state.joinData.token,
                    callType: state.joinData.callType == 'audio'
                        ? CallType.audio
                        : CallType.video,
                    userId: currentUserId,
                    userName: currentUserName,
                    onEndCall: () {
                      log(
                        'EmployeeHomeScreen: onEndCall triggered for callId: ${state.callId}',
                      );
                      context.read<EmployeeCallCubit>().endCall(state.callId);
                    },
                  ),
                ),
              );
            }
          });
        } else if (state is CallIdle) {
          if (Navigator.canPop(context)) Navigator.pop(context);
        }
      },
      child: child,
    );
  }
}
