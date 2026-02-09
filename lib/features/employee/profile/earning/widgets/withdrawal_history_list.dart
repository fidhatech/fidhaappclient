import 'package:dating_app/features/employee/profile/earning/models/withdrawal_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WithdrawalHistoryList extends StatelessWidget {
  final List<WithdrawalHistoryItem> history;
  final bool isLoading;
  final String? error;

  const WithdrawalHistoryList({
    super.key,
    required this.history,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            error!,
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (history.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            children: [
              Icon(
                Icons.history,
                size: 48,
                color: Colors.white.withOpacity(0.3),
              ),
              const SizedBox(height: 12),
              Text(
                "No withdrawal history yet",
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(), // Assuming inside a larger ScrollView
      itemCount: history.length,
      separatorBuilder: (context, index) =>
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
      itemBuilder: (context, index) {
        final item = history[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 0,
          ),
          title: Text(
            "₹${item.amount.toStringAsFixed(0)}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                DateFormat('MMM d, yyyy • h:mm a').format(item.requestedAt),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
              if (item.failureReason != null)
                Text(
                  "Reason: ${item.failureReason}",
                  style: const TextStyle(color: Colors.redAccent, fontSize: 11),
                ),
            ],
          ),
          trailing: _buildStatusChip(item.status),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;
    String label;

    switch (status.toLowerCase()) {
      case 'completed':
        color = Colors.green;
        icon = Icons.check_circle_outline;
        label = 'Paid';
        break;
      case 'failed':
        color = Colors.red;
        icon = Icons.error_outline;
        label = 'Failed';
        break;
      case 'processing':
      default:
        color = Colors.amber;
        icon = Icons.access_time;
        label = 'Processing';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
