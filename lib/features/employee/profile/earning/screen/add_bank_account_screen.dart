import 'package:dating_app/core/validators/app_validator.dart';
import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/core/widgets/loading_dialog/otp_loading_dialog.dart';
import 'package:dating_app/di/injection.dart';
import 'package:dating_app/features/employee/profile/earning/cubit/add_bank_account_cubit.dart';
import 'package:dating_app/features/employee/profile/earning/service/bank_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dating_app/features/employee/profile/earning/kyc/widgets/kyc_submit_button.dart';

class AddBankAccountScreen extends StatelessWidget {
  const AddBankAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddBankAccountCubit(bankService: BankService(sl())),
      child: const _AddBankAccountScreenContent(),
    );
  }
}

class _AddBankAccountScreenContent extends StatefulWidget {
  const _AddBankAccountScreenContent();

  @override
  State<_AddBankAccountScreenContent> createState() =>
      _AddBankAccountScreenContentState();
}

class _AddBankAccountScreenContentState
    extends State<_AddBankAccountScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _holderNameController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();

  @override
  void dispose() {
    _holderNameController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AddBankAccountCubit>().submitBankDetails(
        accountHolderName: _holderNameController.text.trim(),
        bankName: _bankNameController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
        ifscCode: _ifscController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddBankAccountCubit, AddBankAccountState>(
      listener: (context, state) {
        if (state is AddBankAccountLoading) {
          showLoadingDialog(context);
        } else if (state is AddBankAccountSuccess) {
          Navigator.pop(context); // Dismiss loading
          showAppSnackbar(
            context,
            message: state.message,
            icon: Icons.check_circle,
            backgroundColor: Colors.green,
          );
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (context.mounted) {
              Navigator.pop(context);
            }
          });
        } else if (state is AddBankAccountError) {
          Navigator.pop(context); // Dismiss loading
          showAppSnackbar(
            context,
            message: state.message,
            icon: Icons.error_outline,
          );
        }
      },
      child: GradientScaffold(
        appBar: AppBar(
          title: const Text(
            'Add Bank Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Account Holder Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _holderNameController,
                    hint: 'Enter account holder name',
                    validator: AppValidators.name,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Bank Name'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _bankNameController,
                    hint: 'Enter bank name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Bank name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('Account Number'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _accountNumberController,
                    hint: 'Enter account number',
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: AppValidators.accountNumber,
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('IFSC Code'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _ifscController,
                    hint: 'Enter IFSC code',
                    textCapitalization: TextCapitalization.characters,
                    validator: AppValidators.ifsc,
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<AddBankAccountCubit, AddBankAccountState>(
                    builder: (context, state) {
                      return KycSubmitButton(
                        isEnabled: state is! AddBankAccountLoading,
                        isLoading: state is AddBankAccountLoading,
                        onPressed: _handleSubmit,
                        text: 'Submit Details',
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}
