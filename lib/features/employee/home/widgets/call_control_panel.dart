import 'package:dating_app/features/employee/home/widgets/call_toggle_button.dart';
import 'package:flutter/material.dart';

class CallControlPanel extends StatelessWidget {
  final bool isAudioEnabled;
  final bool isVideoEnabled;
  final int audioRate;
  final int videoRate;

  final Function(bool) onToggleAudio;
  final Function(bool) onToggleVideo;

  const CallControlPanel({
    super.key,
    required this.isAudioEnabled,
    required this.isVideoEnabled,
    required this.audioRate,
    required this.videoRate,

    required this.onToggleAudio,
    required this.onToggleVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CallToggleButton(
            icon: isAudioEnabled ? Icons.mic : Icons.mic_off,
            label: 'Audio',
            priceIdx: audioRate,
            isActive: isAudioEnabled,

            onTap: () => onToggleAudio(!isAudioEnabled),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CallToggleButton(
            icon: isVideoEnabled ? Icons.videocam : Icons.videocam_off,
            label: 'Video',
            priceIdx: videoRate,
            isActive: isVideoEnabled,

            onTap: () => onToggleVideo(!isVideoEnabled),
          ),
        ),
      ],
    );
  }
}
