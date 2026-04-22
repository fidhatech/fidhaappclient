import 'package:flutter/material.dart';
import 'widgets/contact_avatar.dart';
import 'widgets/contact_info.dart';
import 'widgets/contact_call_action.dart';

class ContactItem extends StatelessWidget {
  final String name;
  final String age;
  final String imageUrl;
  final bool isOnline;
  final bool isBusy;
  final bool isVideoAvailable;
  final bool isAudioAvailable;
  final int? audioCallRate;
  final int? videoCallRate;
  final VoidCallback onCall;
  final VoidCallback onVideoCall;

  const ContactItem({
    super.key,
    required this.name,
    required this.age,
    required this.imageUrl,
    this.isOnline = true,
    this.isBusy = false,
    this.isVideoAvailable = true,
    this.isAudioAvailable = true,
    this.audioCallRate,
    this.videoCallRate,
    required this.onCall,
    required this.onVideoCall,
  });

  void _showDisabledSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "The user has disabled her video or audio. Try to call when the user comes back.",
        ),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          ContactAvatar(imageUrl: imageUrl, isOnline: isOnline, isBusy: isBusy),
          const SizedBox(width: 16),
          Expanded(
            child: ContactInfo(name: name, age: age),
          ),
          Row(
            children: [
              ContactCallAction(
                icon: Icons.videocam_rounded,
                rate: videoCallRate,
                color: Colors.greenAccent,
                isActive: isVideoAvailable && isOnline,
                onTap: isVideoAvailable && isOnline
                    ? onVideoCall
                    : () => _showDisabledSnackbar(context),
              ),
              const SizedBox(width: 12),
              ContactCallAction(
                icon: Icons.phone_rounded,
                rate: audioCallRate,
                color: Colors.blueAccent,
                isActive: isAudioAvailable && isOnline,
                onTap: isAudioAvailable && isOnline
                    ? onCall
                    : () => _showDisabledSnackbar(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
