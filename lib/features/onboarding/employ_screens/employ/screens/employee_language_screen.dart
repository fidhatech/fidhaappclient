import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/widgets/employee_language_widgets/employee_language_button.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/widgets/employee_language_widgets/employee_language_header.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/widgets/employee_language_widgets/employee_language_list.dart';
import 'package:flutter/material.dart';

class EmployeeLanguageScreen extends StatelessWidget {
  final List<String> languages;
  const EmployeeLanguageScreen({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: RepaintBoundary(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top,
            bottom: MediaQuery.paddingOf(context).bottom,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Stack(
              children: [
                // Main content
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.sizeOf(context).width / 17,
                    right: MediaQuery.sizeOf(context).width / 17,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.sizeOf(context).height / 20),
                      // Fixed Header
                      const EmployeeLanguageHeader(),
                      const SizedBox(height: 30),
                      // Scrollable Language List
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.only(
                            bottom:
                                MediaQuery.sizeOf(context).height *
                                0.30, // Space for bottom button
                          ),
                          child: EmployeeLanguageList(languages),
                        ),
                      ),
                    ],
                  ),
                ),

                // Fixed button section at bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.30,
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
                      children: [EmployeeLanguageButton()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
