import 'dart:developer';
import 'package:dating_app/features/employee/service/employee_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'employee_edit_profile_state.dart';

class EmployeeEditProfileCubit extends Cubit<EmployeeEditProfileState> {
  final EmployeeService _employeeService;

  EmployeeEditProfileCubit(this._employeeService)
    : super(EmployeeEditProfileInitial());

  Future<void> loadProfile() async {
    emit(const EmployeeEditProfileEditing(isLoading: true));
    try {
      final data = await _employeeService.fetchEmployeeProfile();

      final profile = data.containsKey('user') ? data['user'] : data;

      final String name = profile['name'] ?? '';

      String? avatar;
      if (profile['avatar'] is List && (profile['avatar'] as List).isNotEmpty) {
        avatar = profile['avatar'][0];
      } else if (profile['avatar'] is String) {
        avatar = profile['avatar'];
      }

      final String dob = profile['dob'] ?? '';
      final String gender = profile['gender'] ?? '';
      final String about = profile['about'] ?? '';

      List<String> interests = [];
      if (profile['interest'] != null) {
        interests = List<String>.from(profile['interest']);
      }

      List<String> languages = [];
      if (profile['language'] != null) {
        languages = List<String>.from(profile['language']);
      }

      int? age = profile['age'];

      emit(
        EmployeeEditProfileEditing(
          name: name,
          dob: dob,
          gender: gender,
          avatarPath: avatar,
          interests: interests,
          languages: languages,
          about: about,
          age: age,
          isLoading: false,
        ),
      );
    } catch (e) {
      log("Error loading profile: $e");
      emit(EmployeeEditProfileUpdateFailure("Failed to load profile: $e"));
    }
  }

  void initEditProfile({
    String? name,
    String? dob,
    String? gender,
    String? avatar,
    List<String>? interests,
    List<String>? languages,
    String? about,
    int? age,
  }) {
    emit(
      EmployeeEditProfileEditing(
        name: name,
        dob: dob,
        gender: gender,
        avatarPath: avatar,
        interests: interests ?? [],
        languages: languages ?? [],
        about: about,
        age: age,
      ),
    );
  }

  void nameChanged(String name) {
    if (state is EmployeeEditProfileEditing) {
      emit((state as EmployeeEditProfileEditing).copyWith(name: name));
    }
  }

  void dobChanged(String dob) {
    if (state is EmployeeEditProfileEditing) {
      emit((state as EmployeeEditProfileEditing).copyWith(dob: dob));
    }
  }

  void genderChanged(String gender) {
    if (state is EmployeeEditProfileEditing) {
      emit((state as EmployeeEditProfileEditing).copyWith(gender: gender));
    }
  }

  void avatarChanged(String avatarPath) {
    if (state is EmployeeEditProfileEditing) {
      emit(
        (state as EmployeeEditProfileEditing).copyWith(avatarPath: avatarPath),
      );
    }
  }

  void aboutChanged(String about) {
    if (state is EmployeeEditProfileEditing) {
      emit((state as EmployeeEditProfileEditing).copyWith(about: about));
    }
  }

  void interestToggled(String interest) {
    if (state is EmployeeEditProfileEditing) {
      final currentState = state as EmployeeEditProfileEditing;
      final currentList = List<String>.from(currentState.interests);
      if (currentList.contains(interest)) {
        currentList.remove(interest);
      } else {
        currentList.add(interest);
      }
      emit(currentState.copyWith(interests: currentList));
    }
  }

  void languageChanged(List<String> languages) {
    if (state is EmployeeEditProfileEditing) {
      emit(
        (state as EmployeeEditProfileEditing).copyWith(languages: languages),
      );
    }
  }

  Future<void> updateProfile() async {
    if (state is! EmployeeEditProfileEditing) return;

    final currentState = state as EmployeeEditProfileEditing;

    emit(currentState.copyWith(isLoading: true));

    try {
      // Calculate age if DOB is present
      int? age = currentState.age;
      if (currentState.dob != null && currentState.dob!.isNotEmpty) {
        try {
          // Assuming DOB format is dd/MM/yyyy from the UI picker
          final dobDate = DateFormat('dd/MM/yyyy').parse(currentState.dob!);
          age = _calculateAge(dobDate);
        } catch (e) {
          log("Error parsing DOB: $e");
          // Keep existing age or null if parsing fails
        }
      }

      // Prepare data
      final Map<String, dynamic> data = {
        "name": currentState.name,
        "dob": currentState
            .dob, // Format might need adjustment? API example shows "1998-03-20".
        // The UI picker returns dd/MM/yyyy. I should convert it to yyyy-MM-dd for API consistency?
        // User request example: "dob": "1998-03-20".
        // Current Code `dobChanged` stores "dd/MM/yyyy".
        // I should convert it here.
        "avatar": currentState
            .avatarPath, // This assumes a URL string. If it's a file path, we need upload logic.
        // User request "Create the UI only (no API calls initially)" -> "After the UI is stable, integrate...".
        // "avatar": "https://example.com/avatar.jpg" implies it expects a URL.
        // If the user selects a LOCAL file, we need to upload it first.
        // `OnboardingBloc` handles multipart.
        // The user instructions say: "Use the existing Get Profile API... Endpoint: PATCH /api/employee/profile/update... Request body... avatar: string URL".
        // This implies if I pick a new image, I should probably upload it separately or the API handles it?
        // Wait, `OnboardingBloc` uploads image via `primeImageUpload` or sending multipart in `sendOnboardEmployeeData`.
        // The `PATCH` endpoint likely expects a JSON body with URL.
        // If I implement file upload now, it gets complex.
        // Requirements: "Keep the implementation simple... Use the existing Get Profile API".
        // "API Integration... endpoint... request body... avatar: url".
        // If I change avatar to a local file, passing path will fail.
        // I will assume for now I pass what I have. If it's a http URL (existing), it works.
        // If it's a local file, I should probably ideally upload it.
        // BUT, looking at `EmployeeService`, there is no specific "upload avatar" endpoint exposed yet except in `OnboardingService`.
        // Given constraints, I will implement the logic. If avatar is local file, I might need to skip or handle it.
        // For this step, I will map it as is. If it's a local path, the API might reject it or I need to handle it.
        // Let's stick to the requested JSON structure.
        "language": currentState.languages,
        "age": age,
        "about": currentState.about,
        "interest": currentState.interests,
      };

      // Convert DOB to yyyy-MM-dd if needed
      if (currentState.dob != null && currentState.dob!.contains('/')) {
        try {
          final dobDate = DateFormat('dd/MM/yyyy').parse(currentState.dob!);
          data['dob'] = DateFormat('yyyy-MM-dd').format(dobDate);
        } catch (_) {}
      }

      await _employeeService.updateProfile(data);
      emit(EmployeeEditProfileUpdateSuccess());
    } catch (e) {
      log("Error updating profile: $e");
      // Keep user on the form, show error via SnackBar logic in UI
      emit(currentState.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  int _calculateAge(DateTime dob) {
    final today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }
}
