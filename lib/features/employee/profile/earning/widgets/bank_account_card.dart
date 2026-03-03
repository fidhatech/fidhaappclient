import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/features/employee/profile/earning/models/bank_account_model.dart';
import 'package:flutter/material.dart';

class BankAccountCard extends StatelessWidget {
  final BankAccountModel bankAccount;
  final VoidCallback onAddBankTap;

  const BankAccountCard({
    super.key,
    required this.bankAccount,
    required this.onAddBankTap,
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
                'Bank Details',
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
          if (!bankAccount.hasBankDetails) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onAddBankTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryButton,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Add Bank Account',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (bankAccount.hasBankDetails) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            "Account Holder",
            bankAccount.accountHolderName ?? 'N/A',
          ),
          const SizedBox(height: 8),
          _buildInfoRow("Bank Name", bankAccount.bankName ?? 'N/A'),
          const SizedBox(height: 8),
          _buildInfoRow(
            "Account Number",
            _maskAccountNumber(bankAccount.accountNumber),
          ),
          const SizedBox(height: 8),
          _buildInfoRow("IFSC Code", bankAccount.ifscCode ?? 'N/A'),
        ],
      );
    } else {
      return Text(
        "Add your bank account details to receive earnings directly to your bank.",
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

    if (bankAccount.isVerified) {
      badgeColor = Colors.green;
      badgeText = 'Verified';
      icon = Icons.verified;
    } else if (bankAccount.hasBankDetails) {
      badgeColor = Colors.orange;
      badgeText = 'Pending Verification';
      icon = Icons.pending;
    } else {
      badgeColor = Colors.transparent;
      badgeText = '';
      icon = Icons.circle; // Hidden
      return const SizedBox();
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

  String _maskAccountNumber(String? accountNumber) {
    if (accountNumber == null || accountNumber.length < 4) {
      return accountNumber ?? 'N/A';
    }
    return "XXXX${accountNumber.substring(accountNumber.length - 4)}";
  }
}
