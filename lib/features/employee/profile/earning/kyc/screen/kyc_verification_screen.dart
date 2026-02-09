import 'package:dating_app/core/validators/app_validator.dart';
import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/core/widgets/loading_dialog/otp_loading_dialog.dart';
import 'package:dating_app/di/injection.dart';
import 'package:dating_app/features/employee/profile/earning/kyc/cubit/kyc_verification_cubit.dart';
import 'package:dating_app/features/employee/profile/earning/kyc/widgets/kyc_header.dart';
import 'package:dating_app/features/employee/profile/earning/kyc/widgets/kyc_submit_button.dart';
import 'package:dating_app/features/employee/profile/earning/kyc/widgets/pan_input_field.dart';
import 'package:dating_app/features/employee/profile/earning/kyc/widgets/upi_input_field.dart';
import 'package:dating_app/features/employee/profile/earning/service/kyc_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KycVerificationScreen extends StatelessWidget {
  const KycVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KycVerificationCubit(kycService: KycService(sl())),
      child: const _KycVerificationScreenContent(),
    );
  }
}

class _KycVerificationScreenContent extends StatefulWidget {
  const _KycVerificationScreenContent();

  @override
  State<_KycVerificationScreenContent> createState() =>
      _KycVerificationScreenContentState();
}

class _KycVerificationScreenContentState
    extends State<_KycVerificationScreenContent> {
  final _formKey = GlobalKey<FormState>();
  final _upiController = TextEditingController();
  final _panController = TextEditingController();

  bool _isUpiValid = false;
  bool _isPanValid = false;
  bool _isPanVerified = false;
  String? _holderName;

  @override
  void dispose() {
    _upiController.dispose();
    _panController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final panNumber = _panController.text.trim();
      final upiId = _upiController.text.trim();

      context.read<KycVerificationCubit>().submitKyc(
        upiId: upiId,
        panNumber: panNumber,
      );
    } else {
      showAppSnackbar(
        context,
        message: 'Please fill in all required fields correctly',
        icon: Icons.error_outline,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KycVerificationCubit, KycVerificationState>(
      listener: (context, state) {
        if (state is PanVerifying || state is KycVerificationLoading) {
          showLoadingDialog(context);
        } else if (state is PanVerified) {
          Navigator.pop(context); // Dismiss loading
          setState(() {
            _isPanVerified = true;
            _holderName = state.holderName;
          });
          showAppSnackbar(
            context,
            message: 'PAN verified successfully',
            icon: Icons.check_circle,
            backgroundColor: Colors.green,
          );
        } else if (state is KycCompleted) {
          Navigator.pop(context); // Dismiss loading
          showAppSnackbar(
            context,
            message: state.message,
            icon: Icons.check_circle,
            backgroundColor: Colors.green,
          );
          // Navigate back after short delay
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (context.mounted) {
              Navigator.pop(context);
            }
          });
        } else if (state is KycVerificationError) {
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const KycHeader(),
                  const SizedBox(height: 40),

                  // PAN Input (shown first as per reference design)
                  PanInputField(
                    controller: _panController,
                    isVerified: _isPanVerified,
                    holderName: _holderName,
                    isEnabled: !_isPanVerified,
                    onChanged: (value) {
                      setState(() {
                        // Check if PAN is valid using the validator
                        _isPanValid = AppValidators.pan(value) == null;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  // UPI Input
                  UpiInputField(
                    controller: _upiController,
                    onChanged: (value) {
                      setState(() {
                        _isUpiValid = AppValidators.upiId(value) == null;
                      });
                    },
                  ),
                  const SizedBox(height: 40),

                  // Submit Button
                  BlocBuilder<KycVerificationCubit, KycVerificationState>(
                    builder: (context, state) {
                      final isLoading =
                          state is PanVerifying ||
                          state is KycVerificationLoading;

                      // Enable if both fields are valid (and not loading)
                      // If PAN is already verified, we just need key fields valid
                      // (Assuming verified PAN implies valid PAN)
                      final isFormValid =
                          (_isPanVerified || _isPanValid) && _isUpiValid;

                      return KycSubmitButton(
                        isEnabled: isFormValid && !isLoading,
                        isLoading: isLoading,
                        onPressed: _handleSubmit,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
