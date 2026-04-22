import 'dart:developer';
import 'dart:async';

import 'package:dating_app/core/services/firebase_notification_service.dart';
import 'package:dating_app/core/services/incoming_call_notification_bridge.dart';
import 'package:dating_app/core/services/local_notification_service.dart';
import 'package:dating_app/features/employee/employee_home/screen/employee_home_screen.dart';
import 'package:dating_app/features/employee/employee_home/widgets/employee_call_listener.dart';
import 'package:dating_app/features/employee/call/cubit/employee_call_cubit.dart';
import 'package:dating_app/features/employee/home/cubit/employee_cubit.dart';
import 'package:dating_app/features/employee/session/cubit/employee_session_cubit.dart';
import 'package:dating_app/features/employee/home/screens/offline_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class EmployeeHomeWrapper extends StatefulWidget {
  const EmployeeHomeWrapper({super.key});

  @override
  State<EmployeeHomeWrapper> createState() => _EmployeeHomeWrapperState();
}

class _EmployeeHomeWrapperState extends State<EmployeeHomeWrapper> {
  static const MethodChannel _nativeNotificationActionChannel = MethodChannel(
    'fidha.app/notification_actions',
  );
  StreamSubscription<Map<String, dynamic>>? _incomingCallSub;
  String? _lastActionSignature;
  DateTime? _lastActionAt;

  bool _isDuplicateAction(String action, String callId) {
    final now = DateTime.now();
    final signature = '$action::$callId';
    final duplicate =
        _lastActionSignature == signature &&
        _lastActionAt != null &&
        now.difference(_lastActionAt!) < const Duration(seconds: 3);

    _lastActionSignature = signature;
    _lastActionAt = now;
    return duplicate;
  }

  void _forceCancelIncomingCallNotification(String callId) {
    if (callId.isEmpty) {
      return;
    }

    LocalNotificationService.cancelIncomingCallNotification(callId);

    // Some Android builds can briefly re-surface call notifications while
    // lifecycle transitions are still settling after an action tap.
    Future.delayed(const Duration(milliseconds: 400), () {
      LocalNotificationService.cancelIncomingCallNotification(callId);
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      LocalNotificationService.cancelIncomingCallNotification(callId);
    });
  }

  void _handleIncomingBridgePayload(Map<String, dynamic> data) {
    log(
      'EmployeeHomeWrapper: _handleIncomingBridgePayload called with data: $data',
    );
    final callCubit = context.read<EmployeeCallCubit>();
    final action = data['notificationAction']?.toString();
    final callId = data['callId']?.toString() ?? '';

    log(
      'EmployeeHomeWrapper: Processing notification action=$action, callId=$callId',
    );

    if (action == LocalNotificationService.acceptActionId &&
        callId.isNotEmpty) {
      if (_isDuplicateAction(action!, callId)) {
        log(
          'EmployeeHomeWrapper: Duplicate accept action ignored for callId=$callId',
        );
        return;
      }

      log(
        'EmployeeHomeWrapper: Accept action detected, initiating accept call flow',
      );
      _nativeNotificationActionChannel
          .invokeMethod('bringAppToForeground')
          .catchError((Object error) {
            log(
              'EmployeeHomeWrapper: bringAppToForeground failed: $error',
            );
          });
      _forceCancelIncomingCallNotification(callId);

      // Ensure the cubit is in CallRinging before triggering accept.
      // handlePushIncomingCall is a no-op when state is already CallRinging
      // (socket may have delivered the event before the notification tap).
      callCubit.handlePushIncomingCall(data);

      // Use post-frame callback so the widget tree has processed the
      // CallRinging state emission before we attempt to accept.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // Guard: if handlePushIncomingCall silently failed (e.g., state was
        // not CallIdle and socket hasn't set CallRinging either), force it.
        if (callCubit.state is! CallRinging) {
          log(
            'EmployeeHomeWrapper: state not CallRinging after handlePushIncomingCall '
            '(${callCubit.state}). Re-attempting handlePushIncomingCall.',
          );
          callCubit.handlePushIncomingCall(data);
        }
        if (callCubit.state is CallRinging) {
          _forceCancelIncomingCallNotification(callId);
          callCubit.acceptCall(callId);
        } else {
          log(
            'EmployeeHomeWrapper: ⚠️ Cannot auto-accept — '
            'state is ${callCubit.state}. User must tap Accept manually.',
          );
        }
      });
      return;
    }

    if (action == LocalNotificationService.declineActionId &&
        callId.isNotEmpty) {
      if (_isDuplicateAction(action!, callId)) {
        log(
          'EmployeeHomeWrapper: Duplicate decline action ignored for callId=$callId',
        );
        return;
      }

      _forceCancelIncomingCallNotification(callId);
      callCubit.handlePushIncomingCall(data);
      Future.microtask(() => callCubit.rejectCall(callId));
      return;
    }

    callCubit.handlePushIncomingCall(data);
  }

  @override
  void initState() {
    super.initState();
    log("EmployeeHomeWrapper: initState called");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      log("EmployeeHomeWrapper: checking permissions...");
      FirebaseNotificationService.registerTokenWithBackend();
      FirebaseNotificationService.checkAndRequestPermission(context);
    });

    // Trigger initial data load
    context.read<EmployeeCubit>().loadHomeData();

    _incomingCallSub = IncomingCallNotificationBridge.stream.listen((data) {
      if (!mounted) return;
      _handleIncomingBridgePayload(data);
    });

    final pending = IncomingCallNotificationBridge.consumePending();
    if (pending != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _handleIncomingBridgePayload(pending);
      });
    }
  }

  @override
  void dispose() {
    _incomingCallSub?.cancel();
    super.dispose();
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
