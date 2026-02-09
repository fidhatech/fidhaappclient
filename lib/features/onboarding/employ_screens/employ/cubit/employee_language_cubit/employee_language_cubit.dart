import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/features/onboarding/service/onboarding_service.dart';
import 'employee_language_state.dart';

class EmployeeLanguageCubit extends Cubit<EmployeeLanguageState> {
  final OnboardingService onboardingService;

  EmployeeLanguageCubit(this.onboardingService)
    : super(EmployeeLanguageInitial());

  void getLanguages() async {
    emit(EmployeeLanguageLoading());
    final data = await onboardingService.getLanguages();
    log(data.toString());
    emit(LanguageLoaded(List.from(data["languages"])));

    //  return const ["Malayalam", "Tamil", "Kannada", "Hindi"];
  }

  String? _selectedLanguage;

  void selectLanguage(String language) {
    if (_selectedLanguage == language) {
      return;
    }
    _selectedLanguage = language;
    emit(EmployeeLanguageSelected(language));
  }

  Future<void> submit() async {
    if (_selectedLanguage == null) {
      emit(EmployeeLanguageError("Please select a language"));
      return;
    }

    emit(EmployeeLanguageSubmitting());

    try {
      final response = await onboardingService.fetchAudioVerificationText(
        language: _selectedLanguage!,
      );

      emit(
        EmployeeLanguageSuccess(
          language: response['language'],
          textToRead: response['textToRead'],
        ),
      );
    } catch (e) {
      emit(EmployeeLanguageError("Failed to load verification text"));
    }
  }

  void reset() {
    if (state is EmployeeLanguageSuccess && _selectedLanguage != null) {
      emit(EmployeeLanguageSelected(_selectedLanguage!));
    }
  }
}
