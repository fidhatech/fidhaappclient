import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryContactItem extends StatelessWidget {
  final String name;
  final String time;
  final String imageUrl;
  final String callType;
  final String duration;

  const HistoryContactItem({
    super.key,
    required this.name,
    required this.time,
    required this.imageUrl,
    required this.callType,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? callTime;
    try {
      callTime = DateTime.tryParse(time);
    } catch (_) {}

    String formattedDate = '';
    String formattedTime = '';

    if (callTime != null) {
      final now = DateTime.now();
      final difference = now.difference(callTime);

      if (difference.inDays == 0 && callTime.day == now.day) {
        formattedDate = 'Today';
      } else if (difference.inDays == 0 ||
          (difference.inDays == 1 && callTime.day == now.day - 1)) {
        formattedDate = 'Yesterday';
      } else {
        formattedDate = DateFormat('MMM dd').format(callTime);
      }
      formattedTime = DateFormat('hh:mm a').format(callTime);
    } else {
      formattedDate = time;
    }

    String formattedDuration = '${duration}s';
    final int? durationSec = int.tryParse(duration);
    if (durationSec != null && durationSec > 60) {
      final min = durationSec ~/ 60;
      final sec = durationSec % 60;
      formattedDuration = '${min}m ${sec}s';
    }

    IconData typeIcon;
    Color typeColor;

    switch (callType.toLowerCase()) {
      case 'missed':
        typeIcon = Icons.call_missed;
        typeColor = Colors.redAccent;
        break;
      case 'outgoing':
        typeIcon = Icons.call_made;
        typeColor = Colors.greenAccent;
        break;
      case 'incoming':
        typeIcon = Icons.call_received;
        typeColor = Colors.blueAccent;
        break;
      default:
        typeIcon = Icons.phone;
        typeColor = Colors.white70;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.1),
            Colors.white.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: typeColor.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : null,
                  child: imageUrl.isEmpty
                      ? const Icon(Icons.person, color: Colors.white70)
                      : null,
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 12,
                          color: Colors.white54,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$formattedDate • $formattedTime",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(typeIcon, color: typeColor, size: 22),
                  const SizedBox(height: 6),
                  Text(
                    formattedDuration,
                    style: TextStyle(
                      color: typeColor.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
