import 'dart:developer';

import 'package:dating_app/core/services/local_notification_service.dart';
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

  bool get _isAppInForeground =>
      WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;

  void _refreshEmployeeBalanceAfterCall(BuildContext context) {
    final employeeCubit = context.read<EmployeeCubit>();
    employeeCubit.loadHomeData();

    // Reward/coin settlement can arrive slightly after call-end.
    // Trigger one delayed refresh to avoid stale values in home UI.
    Future.delayed(const Duration(seconds: 2), () {
      if (!context.mounted) return;
      employeeCubit.loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCallCubit, EmployeeCallState>(
      listener: (context, state) {
        if (state is CallRinging) {
          if (_isAppInForeground) {
            LocalNotificationService.cancelIncomingCallNotification(
              state.callModel.callId,
            );
          }
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
          LocalNotificationService.cancelIncomingCallNotification(state.callId);
          if (Navigator.canPop(context)) Navigator.pop(context);
        } else if (state is CallAccepting) {
          LocalNotificationService.cancelIncomingCallNotification(state.callId);
          // Call is accepting - wait for server to send joinCall event
          log(
            'EmployeeCallListener: Call is accepting, waiting for joinCall event from server...',
          );
        } else if (state is CallJoining) {
          LocalNotificationService.cancelIncomingCallNotification(state.callId);
          // Server sent joinCall event with Zego credentials
          // Navigate to the actual call UI
          log(
            'EmployeeCallListener: CallJoining state reached, navigating to CallUiKit',
          );

          // If IncomingCallScreen is on the stack (call came from in-app notification),
          // pop it. Otherwise this is a no-op.
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          // Request call permissions and navigate to CallUiKit
          CallPermissionService.requestCallPermissions(context).then((granted) {
            if (!context.mounted) return;
            log('EmployeeCallListener: Call permissions granted=$granted');

            if (granted) {
              final employeeState = context.read<EmployeeCubit>().state;
              String currentUserId = '';
              String currentUserName = 'Employee';

              if (employeeState is EmployeeSuccess) {
                currentUserId = employeeState.employee.id;
                currentUserName = employeeState.employee.name;
              }

              log(
                'EmployeeCallListener: Navigating to CallUiKit - userId=$currentUserId, roomId=${state.joinData.roomId}',
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CallUiKit(
                    appId: state.joinData.appId,
                    callId: state.joinData.roomId,
                    token: state.joinData.token,
                    maxDurationSeconds: state.joinData.maxDurationSeconds,
                    callType: state.joinData.callType == 'audio'
                        ? CallType.audio
                        : CallType.video,
                    userId: currentUserId,
                    userName: currentUserName,
                    onEndCall: () {
                      log(
                        'EmployeeCallListener: onEndCall triggered for callId: ${state.callId}',
                      );
                      context.read<EmployeeCallCubit>().endCall(state.callId);
                    },
                  ),
                ),
              );
            } else {
              log(
                'EmployeeCallListener: Call permissions denied, staying on previous screen',
              );
            }
          });
        } else if (state is CallIdle) {
          // Call ended, pop back to home screen
          if (Navigator.canPop(context)) Navigator.pop(context);
          _refreshEmployeeBalanceAfterCall(context);
        }
      },
      child: child,
    );
  }
}
