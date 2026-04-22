import 'dart:developer';
import 'package:dating_app/core/services/call_foreground_service.dart';
import 'package:dating_app/features/user/features/call/model/call_type.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallUiKit extends StatefulWidget {
  final int appId;
  final String callId;
  final String userId;
  final String userName;
  final String token;
  final int? maxDurationSeconds;

  final CallType callType;
  const CallUiKit({
    super.key,
    required this.appId,
    required this.callId,
    required this.callType,
    required this.userId,
    required this.userName,
    required this.token,
    this.maxDurationSeconds,
    this.onEndCall,
  });

  final VoidCallback? onEndCall;

  @override
  State<CallUiKit> createState() => _CallUiKitState();
}

class _CallUiKitState extends State<CallUiKit> {
  int _elapsedSeconds = 0;
  bool _foregroundServiceStarted = false;

  @override
  void initState() {
    super.initState();
    _startForegroundServiceForCall();
  }

  Future<void> _startForegroundServiceForCall() async {
    await CallForegroundService.start(
      callId: widget.callId,
      callType: widget.callType == CallType.audio ? 'audio' : 'video',
    );
    _foregroundServiceStarted = true;
  }

  Future<void> _stopForegroundServiceForCall() async {
    if (!_foregroundServiceStarted) return;
    await CallForegroundService.stop();
    _foregroundServiceStarted = false;
  }

  String _formatSeconds(int totalSeconds) {
    final mins = totalSeconds ~/ 60;
    final secs = totalSeconds % 60;
    final mm = mins.toString().padLeft(2, '0');
    final ss = secs.toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final maxDuration = widget.maxDurationSeconds;
    final showTimeLeft = maxDuration != null && maxDuration > 0;

    final config = widget.callType == CallType.audio
        ? ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        : ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall();

    // Disable PiP to prevent crash since AndroidManifest does not support it
    config.pip = ZegoCallPIPConfig(enableWhenBackground: false);

    // config.topMenuBar.isVisible = true;
    // config.topMenuBar.buttons = [
    //   ZegoCallMenuBarButtonName.minimizingButton,
    // ];

    // Always show elapsed timer from Zego, and also show remaining time banner.
    config.duration.isVisible = true;
    config.duration.onDurationUpdate = (Duration duration) {
      final seconds = duration.inSeconds;
      if (!mounted || seconds == _elapsedSeconds) return;
      setState(() {
        _elapsedSeconds = seconds;
      });
    };

    final remaining = showTimeLeft
        ? (maxDuration - _elapsedSeconds).clamp(0, maxDuration)
        : 0;

    return Stack(
      children: [
        ZegoUIKitPrebuiltCall(
          appID: widget.appId,
          callID: widget.callId,
          userID: widget.userId,
          userName: widget.userName,
          token: widget.token,
          config: config,
          events: ZegoUIKitPrebuiltCallEvents(
            onError: (error) {
              print('CallUiKit: ❌ Zego Error: $error');

              // Handle exceptions/errors merged from onException
              if (error.toString().contains(
                "STARTPREVIEW_NO_TEXTURERENDERER",
              )) {
                print(
                  "CallUiKit: Ignoring texture renderer error during shutdown.",
                );
                return; // Or continue if you want to run other checks
              }

              try {
                // Attempt to read error code dynamically
                final int code = (error as dynamic).code;
                if (code == 1001005 || code == 1000002) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Call Connection Failed (Error $code). Please retry.",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                }
              } catch (e) {
                print("CallUiKit: Failed to parse error code: $e");
              }
            },
            onCallEnd: (event, defaultAction) {
              log('CallUiKit: onCallEnd triggered. Event: $event');
              widget.onEndCall?.call();
              _stopForegroundServiceForCall();
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            user: ZegoCallUserEvents(
              onLeave: (user) {
                log(
                  'CallUiKit: Remote user left the call: ${user.id} - ${user.name}',
                );
                // onLeave can fire during transient reconnection or media restarts.
                // Let explicit onCallEnd / server call_ended decide teardown.
              },
            ),
          ),
        ),
        if (showTimeLeft)
          Positioned(
            top: MediaQuery.of(context).padding.top + 14,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white38),
              ),
              child: Center(
                child: Text(
                  'Time left ${_formatSeconds(remaining)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _stopForegroundServiceForCall();
    super.dispose();
  }
}
