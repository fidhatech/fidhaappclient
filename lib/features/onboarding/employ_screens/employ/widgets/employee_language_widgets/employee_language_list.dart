import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_language_cubit/employee_language_cubit.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_language_cubit/employee_language_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'employee_language_option.dart';

class EmployeeLanguageList extends StatelessWidget {
  final List<String> languages;
  const EmployeeLanguageList(this.languages, {super.key});
  @override
  Widget build(BuildContext context) {
    // Access languages from the Cubit

    return BlocBuilder<EmployeeLanguageCubit, EmployeeLanguageState>(
      builder: (context, state) {
        String? selected;
        if (state is EmployeeLanguageSelected) {
          selected = state.language;
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: languages.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final language = languages[index];
            final isSelected = selected == language;
            return EmployeeLanguageOption(
              language: language,
              isSelected: isSelected,
              onTap: () {
                context.read<EmployeeLanguageCubit>().selectLanguage(language);
              },
            );
          },
        );
      },
    );
  }
}
