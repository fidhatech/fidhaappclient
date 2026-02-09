import 'dart:ui';
import 'package:dating_app/core/utils/handle_back_press.dart';
import 'package:flutter/material.dart';
import '../widget/pulse_avatar.dart';

class CallWaitingScreen extends StatelessWidget {
  final String calleeName;
  final String? calleeAvatarUrl;
  final VoidCallback onEndCall;

  const CallWaitingScreen({
    super.key,
    required this.calleeName,
    this.calleeAvatarUrl,
    required this.onEndCall,
  });

  Future<void> _handleBackPress(BuildContext context) async {
    await handleBackAction(
      context,
      onAction: onEndCall,
      title: "Cancel Call?",
      message: "Are you sure you want to cancel this call?",
      confirmText: "End Call",
      confirmColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBackPress(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Blurred Background
            if (calleeAvatarUrl != null)
              Positioned.fill(
                child: Image.network(calleeAvatarUrl!, fit: BoxFit.cover),
              ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(color: Colors.black.withValues(alpha: 0.6)),
              ),
            ),

            // Content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  // Avatar with Pulse Effect
                  PulseAvatar(avatarUrl: calleeAvatarUrl, size: 160),
                  const SizedBox(height: 48),
                  // Callee Name
                  Text(
                    calleeName,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Status Text with Dot Animation
                  const _TypingDots(),
                  const Spacer(flex: 3),
                  // Call Controls
                  Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: onEndCall,
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.red.shade600,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withValues(alpha: 0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            "End Call",
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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

class _TypingDots extends StatefulWidget {
  const _TypingDots();

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotCount;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _dotCount = IntTween(begin: 0, end: 3).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dotCount,
      builder: (context, child) {
        String dots = '.' * (_dotCount.value + 1);
        return Text(
          "Connecting$dots",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.7),
            letterSpacing: 1.1,
          ),
        );
      },
    );
  }
}
