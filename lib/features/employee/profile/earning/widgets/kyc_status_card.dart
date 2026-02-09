import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/features/employee/profile/earning/models/kyc_status_model.dart';
import 'package:flutter/material.dart';

class KycStatusCard extends StatelessWidget {
  final EmployeeKycStatusModel kycStatus;
  final VoidCallback onVerifyTap;

  const KycStatusCard({
    super.key,
    required this.kycStatus,
    required this.onVerifyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'KYC Status',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: 16),
          _buildContent(),
          if (!kycStatus.isCompleted) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onVerifyTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryButton,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _getButtonText(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (kycStatus.isCompleted) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("PAN Holder", kycStatus.panHolderName ?? 'N/A'),
          const SizedBox(height: 8),
          _buildInfoRow("UPI ID", kycStatus.upiId ?? 'N/A'),
        ],
      );
    } else if (kycStatus.panVerified) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 16),
              const SizedBox(width: 6),
              Text(
                "PAN Verified",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Add UPI ID to complete KYC",
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ],
      );
    } else {
      return Text(
        "Complete KYC verification to verify your account and withdraw earnings.",
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontSize: 14,
          height: 1.4,
        ),
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color badgeColor;
    String badgeText;
    IconData icon;

    if (kycStatus.isCompleted) {
      badgeColor = Colors.green;
      badgeText = 'Completed';
      icon = Icons.verified;
    } else if (kycStatus.hasKYC) {
      badgeColor = Colors.orange;
      badgeText = 'Pending';
      icon = Icons.pending;
    } else {
      badgeColor = Colors.redAccent;
      badgeText = 'Not Started';
      icon = Icons.warning_amber_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: badgeColor, size: 12),
          const SizedBox(width: 4),
          Text(
            badgeText,
            style: TextStyle(
              color: badgeColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    if (kycStatus.panVerified) return 'Add UPI ID';
    if (kycStatus.hasKYC) {
      return 'Check Status'; // Should rarely hit if logic is correct
    }
    return 'Verify Now';
  }
}
