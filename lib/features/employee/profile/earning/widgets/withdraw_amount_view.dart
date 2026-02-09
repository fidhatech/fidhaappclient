import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

class WithdrawAmountView extends StatefulWidget {
  final double availableBalance;
  final Function(int) onWithdraw;

  const WithdrawAmountView({
    super.key,
    required this.availableBalance,
    required this.onWithdraw,
  });

  @override
  State<WithdrawAmountView> createState() => _WithdrawAmountViewState();
}

class _WithdrawAmountViewState extends State<WithdrawAmountView> {
  final TextEditingController _amountController = TextEditingController();
  final int _platformFee = 5;
  int? _amount;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_validateAmount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _validateAmount() {
    setState(() {
      if (_amountController.text.isEmpty) {
        _amount = null;
        _errorText = null;
        return;
      }

      final parsed = int.tryParse(_amountController.text);
      if (parsed == null) {
        _errorText = "Invalid amount";
        _amount = null;
        return;
      }

      if (parsed <= 0) {
        _errorText = "Amount must be greater than 0";
        _amount = null;
        return;
      }

      if (parsed > widget.availableBalance) {
        _errorText = "Insufficient balance";
        _amount = null;
        return;
      }

      // Check if amount covers the fee logic?
      // Assuming user receives (Input Amount - Fee).
      // If user inputs 5 and fee is 5, net is 0. So maybe allow >= Fee + 1?
      // For now, simple logic: Input > 0.

      _amount = parsed;
      _errorText = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate net amount for preview
    final netAmount = (_amount != null && _amount! > _platformFee)
        ? _amount! - _platformFee
        : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Withdraw Money",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Available Balance: ₹${widget.availableBalance.toStringAsFixed(2)}",
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Enter Amount",
              prefixText: "₹ ",
              errorText: _errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColor.primaryPink,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Fee Breakdown
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildSummaryRow("Requested Amount", "₹${_amount ?? 0}"),
                const SizedBox(height: 8),
                _buildSummaryRow(
                  "Platform Fee",
                  "-₹$_platformFee",
                  isDeduction: true,
                ),
                const Divider(height: 24),
                _buildSummaryRow("You Receive", "₹$netAmount", isBold: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: (_amount != null && _errorText == null)
                ? () {
                    // MOCK SUBMISSION as per instructions
                    // Logic to pass amount up would go here
                    // widget.onWithdraw(_amount!);

                    // Show disabled feedback or mock logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Withdrawals are coming soon!"),
                      ),
                    );
                    Navigator.pop(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryPink,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              disabledBackgroundColor: Colors.grey[300],
            ),
            child: const Text(
              "Request Withdrawal",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16), // Bottom padding/safe area buffer
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isDeduction = false,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDeduction
                ? Colors.red
                : (isBold ? Colors.black : Colors.black87),
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
