import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/widgets/custom_elevated_button/custom_elevated_button.dart';
import 'package:dating_app/features/user/features/home/bloc/home_bloc.dart';
import 'package:dating_app/features/user/features/home/bloc/home_event.dart';
import 'package:dating_app/features/user/features/home/cubit/filter_cubit.dart';
import 'package:dating_app/features/user/features/home/cubit/filter_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterActionSection extends StatelessWidget {
  const FilterActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: CustomButton(
            text: 'Apply',
            onPressed: () {
              final filterState = context.read<FilterCubit>().state;
              if (filterState is FilterLoaded) {
                final String? selectedLanguage =
                    filterState.selectedLanguages.isNotEmpty
                    ? filterState.selectedLanguages.first
                    : null;

                if (selectedLanguage != null) {
                  context.read<HomeBloc>().add(Filter(selectedLanguage));
                }
              }
              Navigator.pop(context);
            },
            backgroundColor: AppColor.primaryPink,
            heightMultiplier: 15,
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Terms and Conditions Terms and\nConditions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.secondaryText,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
