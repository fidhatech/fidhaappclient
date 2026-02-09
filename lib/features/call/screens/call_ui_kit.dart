import 'dart:developer';
import 'package:dating_app/features/user/features/call/model/call_type.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallUiKit extends StatelessWidget {
  final int appId;
  final String callId;
  final String userId;
  final String userName;
  final String token;

  final CallType callType;
  const CallUiKit({
    super.key,
    required this.appId,
    required this.callId,
    required this.callType,
    required this.userId,
    required this.userName,
    required this.token,
    this.onEndCall,
  });

  final VoidCallback? onEndCall;

  @override
  Widget build(BuildContext context) {
    final config = callType == CallType.audio
        ? ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        : ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall();

    // Disable PiP to prevent crash since AndroidManifest does not support it
    config.pip = ZegoCallPIPConfig(enableWhenBackground: false);

    // config.topMenuBar.isVisible = true;
    // config.topMenuBar.buttons = [
    //   ZegoCallMenuBarButtonName.minimizingButton,
    // ];

    // Configure duration events to handle call lifecycle
    config.duration.isVisible = true;
    config.duration.onDurationUpdate = (Duration duration) {
      // Optional: track call duration
    };

    return ZegoUIKitPrebuiltCall(
      appID: appId,
      callID: callId,
      userID: userId,
      userName: userName,
      token: token,
      config: config,
      events: ZegoUIKitPrebuiltCallEvents(
        onError: (error) {
          print('CallUiKit: ❌ Zego Error: $error');

          // Handle exceptions/errors merged from onException
          if (error.toString().contains("STARTPREVIEW_NO_TEXTURERENDERER")) {
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
          onEndCall?.call();
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        user: ZegoCallUserEvents(
          onLeave: (user) {
            // When remote user leaves/hangs up
            log(
              'CallUiKit: Remote user left the call: ${user.id} - ${user.name}',
            );
            // Auto-end the call when the other person leaves
            log('CallUiKit: Auto-ending call because remote user left');
            onEndCall?.call();
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
