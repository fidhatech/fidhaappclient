import 'dart:ui';
import 'dart:developer';
import 'package:dating_app/core/services/local_notification_service.dart';
import 'package:dating_app/core/utils/handle_back_press.dart';
import 'package:dating_app/features/call/call_waiting/widget/pulse_avatar.dart';
import 'package:dating_app/features/call/incoming_call/widgets/incoming_call_button.dart';
import 'package:dating_app/features/employee/call/cubit/employee_call_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomingCallScreen extends StatelessWidget {
  final String callerName;
  final String callId;
  final String? callerAvatarUrl;

  const IncomingCallScreen({
    super.key,
    required this.callerName,
    required this.callId,
    this.callerAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await handleBackAction(
          context,
          onAction: () {
            log('IncomingCallScreen: Back button logic triggered reject');
            LocalNotificationService.cancelIncomingCallNotification(callId);
            context.read<EmployeeCallCubit>().rejectCall(callId);
          },
          title: "Reject Call?",
          message: "Are you sure you want to reject this incoming call?",
          confirmText: "Reject Call",
          confirmColor: Colors.red,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Thematic Blurred Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6A007F), Color(0xFF0D001A)],
                  ),
                ),
              ),
            ),
            if (callerAvatarUrl != null)
              Positioned.fill(
                child: Image.network(callerAvatarUrl!, fit: BoxFit.cover),
              ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(color: Colors.black.withValues(alpha: 0.5)),
              ),
            ),

            // Main Content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Avatar with Ripples
                  PulseAvatar(avatarUrl: callerAvatarUrl, size: 150),
                  const SizedBox(height: 40),
                  // Status + Name
                  const _IncomingTextPulse(),
                  const SizedBox(height: 12),
                  Text(
                    callerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      shadows: [
                        Shadow(
                          color: Colors.black45,
                          offset: Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 4),
                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 80.0,
                      left: 50,
                      right: 50,
                    ),
                    child: BlocBuilder<EmployeeCallCubit, EmployeeCallState>(
                      builder: (context, state) {
                        final isProcessing =
                            state is CallRejecting || state is CallAccepting;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Reject Button Column
                            _ActionButtonWithLabel(
                              label: "Decline",
                              button: IncomingCallButton(
                                color: Colors.red.shade600,
                                icon: Icons.call_end,
                                onTap: isProcessing
                                    ? null
                                    : () {
                                        log(
                                          'IncomingCallScreen: Reject tapped',
                                        );
                                        LocalNotificationService
                                            .cancelIncomingCallNotification(
                                              callId,
                                            );
                                        context
                                            .read<EmployeeCallCubit>()
                                            .rejectCall(callId);
                                      },
                              ),
                            ),
                            // Accept Button Column
                            _ActionButtonWithLabel(
                              label: "Accept",
                              button: IncomingCallButton(
                                color: Colors.green.shade600,
                                icon: Icons.call,
                                onTap: isProcessing
                                    ? null
                                    : () {
                                        log(
                                          'IncomingCallScreen: Accept tapped',
                                        );
                                        LocalNotificationService
                                            .cancelIncomingCallNotification(
                                              callId,
                                            );
                                        context
                                            .read<EmployeeCallCubit>()
                                            .acceptCall(callId);
                                      },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomingTextPulse extends StatefulWidget {
  const _IncomingTextPulse();

  @override
  State<_IncomingTextPulse> createState() => _IncomingTextPulseState();
}

class _IncomingTextPulseState extends State<_IncomingTextPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: const Text(
        'Incoming Call...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

class _ActionButtonWithLabel extends StatelessWidget {
  final String label;
  final Widget button;

  const _ActionButtonWithLabel({required this.label, required this.button});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        button,
        const SizedBox(height: 12),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
