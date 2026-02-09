import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/core/utils/url_helper.dart';
import 'package:dating_app/core/widgets/confirm_button_with_text/confirm_button_with_text.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:dating_app/features/onboarding/screens/gender_selection_screen.dart';
import 'package:dating_app/features/onboarding/widgets/dob_screen_widgets/dob_header.dart';
import 'package:dating_app/features/onboarding/widgets/dob_screen_widgets/dob_selector_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DobScreen extends StatefulWidget {
  const DobScreen({super.key});

  @override
  State<DobScreen> createState() => _DobScreenState();
}

class _DobScreenState extends State<DobScreen> {
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime eighteenYearsAgo = DateTime(
      now.year - 18,
      now.month,
      now.day,
    );

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          selectedDate ??
          (eighteenYearsAgo.isBefore(DateTime(2000))
              ? eighteenYearsAgo
              : DateTime(2000)),
      firstDate: DateTime(1900),
      lastDate: eighteenYearsAgo,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColor.highlightColor,
              onPrimary: Colors.white,
              surface: AppColor.secondary,
              onSurface: Colors.white,
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColor.secondary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: controlWidth(context, 17),
                  right: controlWidth(context, 17),
                  bottom: screenHeightPercentage(context, 0.30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: controlHeight(context, 40)),
                    const DobHeader(),
                    SizedBox(height: controlHeight(context, 21)),

                    DobSelectorField(
                      selectedDate: selectedDate,
                      onTap: () => _selectDate(context),
                    ),
                    SizedBox(height: controlHeight(context, 20)),

                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.asset(
                            'assets/images/onboarding_images/girl_sketch1.png',
                            height: MediaQuery.of(context).size.height * 0.30,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            top: 10,
                            left: 80,
                            right: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.highlightColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Date of Birth',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: controlHeight(context, 20)),
                  ],
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: screenHeightPercentage(context, 0.30),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.5),
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConfirmButtonWithText(
                        buttonText: 'Confirm',
                        bottomText:
                            'By continuing, you agree to our Terms & Conditions',
                        onBottomTextTap: () =>
                            UrlHelper.launchURL(AppUrls.termsAndConditions),
                        isEnabled: selectedDate != null,
                        onTap: () {
                          if (selectedDate != null) {
                            context.read<OnboardingBloc>().add(
                              DobSubmitted(selectedDate!),
                            );
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const GenderSelectionScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
