import 'package:dating_app/features/onboarding/screens/dob_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../../core/utils/mediaquery.dart';
import '../../../core/widgets/custom_elevated_button/custom_elevated_button.dart';
import '../../../core/widgets/custom_textfield/custom_textfield.dart';
import '../../../core/widgets/custom_textfield/custom_textfield_styles.dart';
import '../../../core/widgets/gradient_scaffold/gradient_scaffold.dart';
import '../cubit/onboard_abroad_user_cubit/onboard_abroad_user_cubit.dart';

class AbroadUserDetailsEntryScreen extends StatefulWidget {

  final String email;
  final String name;

  const AbroadUserDetailsEntryScreen({
    super.key,
    required this.email,
    required this.name,
  });

  @override
  State<AbroadUserDetailsEntryScreen> createState() => _AbroadUserDetailsEntryScreenState();
}

class _AbroadUserDetailsEntryScreenState extends State<AbroadUserDetailsEntryScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final PhoneController _phoneController = PhoneController();

  final OnboardAbroadUserCubit _cubit = OnboardAbroadUserCubit();

  void _listenOnboardUserCubit(BuildContext context, OnboardAbroadUserState state) { 
    if (state is OnboardAbroadUserSuccess) {
      Navigator
        .of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => const DobScreen(),
          ),
        );
    } else if (state is OnboardAbroadUserFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    
    _nameController.text = widget.name;
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _cubit.close();

    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: .symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'Abroad User Details Entry',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  controller: _nameController,
                  hint: "What's Your Name",
                  onChanged: (value) {
                    // Handle text change
                  },
                  textColor: Colors.white,
                  hintColor: Colors.white54,
                  borderColor: Colors.white.withValues(alpha: 0.1),
                  focusedBorderColor: Colors.white.withValues(alpha: 0.3),
                  borderRadius: 15,
                  verticalPadding: controlHeight(context, 45),
                  textSize: getResponsiveFontSize(context, mobile: 16),
                  fillColor: const Color.fromARGB(255, 185, 74, 74).withValues(alpha: 0.05),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  hint: "What's Your Email",
                  onChanged: (value) {
                    // Handle text change
                  },
                  textColor: Colors.white,
                  hintColor: Colors.white54,
                  borderColor: Colors.white.withValues(alpha: 0.1),
                  focusedBorderColor: Colors.white.withValues(alpha: 0.3),
                  borderRadius: 15,
                  verticalPadding: controlHeight(context, 45),
                  textSize: getResponsiveFontSize(context, mobile: 16),
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  readOnly: true, // Email is read-only as it's fetched from Google Sign-In
                ),
                const SizedBox(height: 20),
                PhoneFormField(
                  controller: _phoneController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getResponsiveFontSize(context, mobile: 16),
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 15,
                    ),
                    hintText: "What's Your Phone Number",
                    hintStyle: TextStyle(
                      color: Colors.white54,
                      fontSize: getResponsiveFontSize(context, mobile: 16),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.05),
                    enabledBorder: CustomTextFieldStyles().enabledBorder(
                      radius: .circular(15),
                      borderColor: Colors.white.withValues(alpha: 0.1),
                      borderWidth: 2,
                    ),
                    focusedBorder: CustomTextFieldStyles().focusedBorder(
                      radius: .circular(15),
                      focusedBorderColor: Colors.white.withValues(alpha: 0.3),
                      focusedBorderWidth: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                BlocConsumer<OnboardAbroadUserCubit, OnboardAbroadUserState>(
                  bloc: _cubit,
                  listener: _listenOnboardUserCubit,
                  builder: (context, state) => CustomButton(
                    onPressed: () {
                      _cubit.onboardUser(
                        email: _emailController.text,
                        name: _nameController.text,
                        phone: '${_phoneController.value.countryCode}-${_phoneController.value.nsn}',
                      );
                    },
                    text: "Continue",
                    heightMultiplier: 16,
                    textSize: getResponsiveFontSize(context, mobile: 16),
                    isLoading: state is OnboardAbroadUserLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}