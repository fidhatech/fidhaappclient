
import 'dart:developer';

import 'package:dating_app/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart'; // ignore: unused_import
import 'package:image_picker/image_picker.dart';
import 'employee_face_reveal_state.dart';

/// Manages the state for the Face Reveal screen.
class EmployeeFaceRevealCubit extends Cubit<EmployeeFaceRevealState> {
  final OnboardingBloc bloc;
  EmployeeFaceRevealCubit(this.bloc) : super(EmployeeFaceRevealInitial());

  final List<String?> _mediaFiles = List.filled(4, null, growable: false);
  final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery and updates the specific slot at [index].
  ///
  /// If an image is successfully picked, it overwrites the existing image (if any)
  /// at the given [index] and emits [EmployeeFaceRevealUpdated].
  Future<void> pickImage(int index) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _mediaFiles[index] = image.path;
        emit(EmployeeFaceRevealUpdated(mediaFiles: List.from(_mediaFiles)));
      }
    } catch (e) {
      log("Error picking image: $e");
    }
  }

  /// Removes the media at the given path (Not currently used in UI but kept for completeness).
  void removeMedia(String mediaPath) {
    // Logic to remove media
    _mediaFiles.remove(mediaPath);
    emit(EmployeeFaceRevealUpdated(mediaFiles: List.from(_mediaFiles)));
  }

  /// Handles the "Skip" action.
  void skip() {
    // Handle skip logic
    // e.g., Navigate to next screen
    bloc.add(PremiumEmployee());
    log("Skipped Face Reveal");
  }

  /// Handles the "Confirm" action.
  ///
  /// Proceed only if necessary validation passes (logic to be implemented).
  void confirm() {
    log(_mediaFiles.toString());
    // Handle confirm logic
    // e.g., Validate and submit
    if (_mediaFiles.isNotEmpty) {
      log(_mediaFiles.whereType<String>().toList().toString());
      bloc.add(PremiumEmployee(_mediaFiles.whereType<String>().toList()));
      // Add logic to proceed
    } else {
      log("No media selected");
      // Show error or handle accordingly
    }
  }
}
