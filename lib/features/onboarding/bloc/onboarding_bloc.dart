import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/core/services/firebase_notification_service.dart';
import 'package:dating_app/core/storage/secure_storage.dart';
import 'package:dating_app/di/injection.dart';
import 'package:dating_app/features/onboarding/models/on_boarding_model.dart';
import 'package:dating_app/features/onboarding/service/onboarding_service.dart';

import 'package:dio/dio.dart';

import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingState()) {
    on<PhoneSubmitted>(_onPhoneSubmitted);
    on<NameSubmitted>(_onNameSubmitted);
    on<DobSubmitted>(_onDobSubmitted);
    on<GenderAvatarSubmitted>(_onGenderAvatarSubmitted);
    on<FemaleExtraSubmitted>(_onfemaleextrasubmitted);
    on<FemaleSubmit>(_onfemalesubmit);
    on<VerificationChecked>(_onVerificationChecked);
    on<PremiumEmployee>(_onPremium);
  }

  void _onPhoneSubmitted(PhoneSubmitted event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(phone: event.number));
  }

  void _onNameSubmitted(NameSubmitted event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onDobSubmitted(DobSubmitted event, Emitter<OnboardingState> emit) {
    String dobString = DateFormat('yyyy-MM-dd').format(event.dob);

    emit(state.copyWith(dob: dobString));
  }

  void _onGenderAvatarSubmitted(
    GenderAvatarSubmitted event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(
      state.copyWith(
        gender: event.gender,
        avatar: event.avatar,
        status: OnboardingStatus.loading,
      ),
    );

    if (event.gender == 'Male') {
      try {
        final maleRequest = MaleOnboarding(
          name: state.name ?? '',
          gender: state.gender ?? "",
          dob: state.dob ?? '',
          phone: state.phone ?? '',
          avatar: event.avatar,
        );
        await sl<OnboardingService>().sendOnboardData(maleRequest.toJson());
        // Save Role for Offline Access
        await SecureStorage.saveUserRole('client');
        emit(state.copyWith(status: OnboardingStatus.success));
      } catch (e) {
        emit(state.copyWith(status: OnboardingStatus.failure));
      }
    } else {
      emit(state.copyWith(status: OnboardingStatus.moreDetailsRequired));
    }
  }

  int calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;

    // If birthday hasn’t occurred yet this year, subtract 1
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }

    return age;
  }

  void _onfemaleextrasubmitted(
    FemaleExtraSubmitted event,
    Emitter<OnboardingState> emit,
  ) {
    final age = calculateAge(DateTime.parse(state.dob!));
    emit(
      state.copyWith(
        age: age.toString(),
        interest: event.interest,
        about: event.about,
        audioPath: event.audioPath,
        language: event.language,
      ),
    );
  }

  void _onfemalesubmit(
    FemaleSubmit event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.loading));
    try {
      // Create the final data map for multipart
      final femaleModel = FemaleOnboarding(
        age: state.age ?? "",
        name: state.name ?? '',
        gender: state.gender ?? 'female',
        dob: state.dob ?? '',
        phone: state.phone ?? '',
        avatar: state.avatar ?? '',
        audio: event.audioPath,
        about: state.about ?? '',
        language: event.language,
        interest: state.interest,
      );

      final Map<String, dynamic> payload = femaleModel.toJson();
      log(payload.toString());
      // 3. Replace the audio path string with the actual MultipartFile
      payload['audio'] = await MultipartFile.fromFile(
        event.audioPath,
        filename: "voice_auth.m4a",
      );
      log("after audio bengn form data ${payload.toString()}");
      final tokens = await sl<OnboardingService>().sendOnboardEmployeeData(
        payload,
      );

      log("tokens ${tokens.toString()}");
      await SecureStorage.saveTokens(
        accessToken: tokens['accessToken']!,
        refreshToken: tokens['refreshToken']!,
      );
      await FirebaseNotificationService.registerTokenWithBackend();
      // Save Role for Offline Access
      await SecureStorage.saveUserRole('employee');
      emit(state.copyWith(status: OnboardingStatus.moreDetailsRequired));
    } catch (e) {
      emit(state.copyWith(status: OnboardingStatus.onDioError));
    }
  }

  void _onVerificationChecked(
    VerificationChecked event,
    Emitter<OnboardingState> emit,
  ) async {
    emit(state.copyWith(status: OnboardingStatus.loading));
    try {
      final userInfo = {
        "phone": state.phone,
        "name": state.name,
        "gender": state.gender,
        "dob": state.dob,
        "avatar": state.avatar,
      };

      final response = await sl<OnboardingService>().checkVerificationStatus(
        userInfo,
      );

      // STRICT CHECK: Only move forward if status is approved
      if (response['status'] == 'approved') {
        emit(state.copyWith(status: OnboardingStatus.success));
      } else {
        // Stay on screen and show message
        emit(state.copyWith(status: OnboardingStatus.failure));
        log("Verification not approved yet: ${response['status']}");
      }
    } catch (e) {
      emit(state.copyWith(status: OnboardingStatus.failure));
    }
  }

  Future<void> _onPremium(
    PremiumEmployee event,
    Emitter<OnboardingState> emit,
  ) async {
    if (event.list?.isEmpty ?? true) {
      emit(state.copyWith(status: OnboardingStatus.success));
    } else {
      final images = event.list!.whereType<String>().toList();
      try {
        await sl<OnboardingService>().primeImageUpload(images);
        emit(state.copyWith(status: OnboardingStatus.success));
      } catch (e) {
        emit(state.copyWith(status: OnboardingStatus.failure));
      }
    }
  }
}
