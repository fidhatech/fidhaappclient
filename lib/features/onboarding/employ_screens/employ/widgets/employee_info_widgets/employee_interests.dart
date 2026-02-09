import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_info_cubit/employee_info_cubit.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_info_cubit/employee_info_state.dart';
import 'package:dating_app/config/theme/app_color.dart';

class EmployeeInterests extends StatelessWidget {
  const EmployeeInterests({super.key});

  static final List<String> _interests = [
    "Love",
    "Movies and cinema",
    "Romantic",
    "Emotional or supportive talk",
    "Career",
    "Childhood memories",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select your interests",
          style: TextStyle(
            color: AppColor.primaryText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<EmployeeInfoCubit, EmployeeInfoState>(
          builder: (context, state) {
            List<String> selected = [];
            if (state is EmployeeInfoUpdated) {
              selected = state.selectedInterests;
            }

            return Wrap(
              spacing: 8,
              runSpacing: 10,
              children: _interests.map((interest) {
                final isSelected = selected.contains(interest);
                return GestureDetector(
                  onTap: () {
                    context.read<EmployeeInfoCubit>().toggleInterest(interest);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.primaryText
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColor.primaryText, width: 1),
                    ),
                    child: Text(
                      interest,
                      style: TextStyle(
                        color: isSelected ? Colors.black : AppColor.primaryText,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
