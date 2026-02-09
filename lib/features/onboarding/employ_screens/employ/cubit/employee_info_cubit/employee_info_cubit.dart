import 'dart:developer';

import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_language_cubit/employee_language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'employee_info_state.dart';

class EmployeeInfoCubit extends Cubit<EmployeeInfoState> {
  EmployeeInfoCubit() : super(EmployeeInfoInitial());

  final List<String> _selectedInterests = [];

  void toggleInterest(String interest) {
    if (_selectedInterests.contains(interest)) {
      _selectedInterests.remove(interest);
    } else {
      _selectedInterests.add(interest);
    }
    emit(EmployeeInfoUpdated(selectedInterests: List.from(_selectedInterests)));
  }

  void submit(String about, BuildContext context) {
    if (about.isEmpty || _selectedInterests.isEmpty) {
      showAppSnackbar(
        context,
        message: "Please fill all fields and select at least one interest",
        icon: Icons.error_outline,
        backgroundColor: Colors.red, // optional, defaults to red
      );
      return;
    }
    // Proceed with submission
    log("Submitting: About: $about, Interests: $_selectedInterests");
    context.read<OnboardingBloc>().add(
      FemaleExtraSubmitted(about: about, interest: _selectedInterests),
    );
    context.read<EmployeeLanguageCubit>().getLanguages();
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => EmployeeLanguageScreen()),
    // );
  }
}
