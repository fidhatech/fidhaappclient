import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/core/network/socket/socket_service.dart';
import 'package:dating_app/core/services/socket_session_manager.dart';
import 'package:dating_app/core/storage/secure_storage.dart';
import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:dating_app/features/user/features/home/bloc/home_bloc.dart';
import 'package:dating_app/features/user/features/home/bloc/home_event.dart';
import 'package:dating_app/features/user/features/user_profile/services/profile_service.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileService _profileService;
  final GetIt sl = GetIt.instance;

  ProfileCubit({required ProfileService profileService})
    : _profileService = profileService,
      super(ProfileInitial());

  Future<void> logout() async {
    log("ProfileCubit: Logout requested");
    emit(ProfileLoading());
    try {
      Map<String, dynamic> body = {};
      if (sl.isRegistered<UserCubit>()) {
        final userState = sl<UserCubit>().state;
        if (userState is UserLoaded) {
          final user = userState.userModel;
          body = {
            'name': user.name,
            'gender': '',
            'dob': '',
            'avatar': user.avatar,
          };
        }
      }

      log("ProfileCubit: Calling profileService.logout");
      await _profileService.logout(body);
      log("ProfileCubit: API logout successful, performing cleanup");

      await _performCleanup();

      log("ProfileCubit: Emitting LogoutSuccess");
      emit(LogoutSuccess());
    } catch (e) {
      log("ProfileCubit: Logout API error: $e");
      await _performCleanup();
      emit(LogoutSuccess());
    }
  }

  Future<void> loadProfileForEditing(String? currentGender) async {
    emit(EditProfileLoading());
    try {
      final profile = await _profileService.getProfile();
      emit(
        ProfileEditing(
          name: profile.name,
          dob: profile.dob != null && profile.dob!.contains('T')
              ? profile.dob!.split('T').first
              : (profile.dob ?? ''),
          about: profile.about ?? '',
          gender:
              currentGender, // Preserve gender from UserCubit or previous state
          avatarPath: profile.avatar,
        ),
      );
    } catch (e) {
      log("ProfileCubit: Failed to load profile for editing: $e");

      emit(ProfileUpdateFailure("Failed to load profile details"));
    }
  }

  void initEditProfile({
    required String name,
    required String dob,
    String? gender,
    String? avatar,
  }) {
    emit(
      ProfileEditing(name: name, dob: dob, avatarPath: avatar, gender: gender),
    );
  }

  void nameChanged(String name) {
    if (state is ProfileEditing) {
      emit((state as ProfileEditing).copyWith(name: name));
    }
  }

  void dobChanged(String dob) {
    if (state is ProfileEditing) {
      emit((state as ProfileEditing).copyWith(dob: dob));
    }
  }

  void avatarChanged(String path) {
    if (state is ProfileEditing) {
      emit((state as ProfileEditing).copyWith(avatarPath: path));
    }
  }

  void aboutChanged(String value) {
    if (state is ProfileEditing) {
      emit((state as ProfileEditing).copyWith(about: value));
    }
  }

  Future<void> updateProfile() async {
    if (state is! ProfileEditing) return;
    final currentState = state as ProfileEditing;

    if (currentState.name == null || currentState.name!.trim().isEmpty) {
      emit(currentState.copyWith(errorMessage: "Name cannot be empty"));
      return;
    }

    log("ProfileCubit: Update Profile requested");
    emit(currentState.copyWith(isLoading: true, errorMessage: null));

    try {
      await _profileService.updateProfile(
        name: currentState.name,
        dob: currentState.dob,
        avatar: currentState.avatarPath,
        about: currentState.about,
      );

      log("ProfileCubit: Update successful");
      emit(ProfileUpdateSuccess());

      // Refresh User Data
      if (sl.isRegistered<UserCubit>()) {
        sl<UserCubit>().fetchUser();
      }
    } catch (e) {
      log("ProfileCubit: Update error: $e");
      emit(ProfileUpdateFailure(e.toString()));
    }
  }

  Future<void> deleteAccount() async {
    log("ProfileCubit: Delete Account requested");
    emit(ProfileLoading());
    try {
      await _profileService.deleteAccount();
      log("ProfileCubit: API delete successful");
      await _performCleanup();
      emit(DeleteAccountSuccess());
    } catch (e) {
      log("ProfileCubit: Delete API error: $e");
      emit(DeleteAccountFailure(e.toString()));
    }
  }

  Future<void> _performCleanup() async {
    log("Cleanup: Starting cleanup process...");
    try {
      // Disconnect Socket & Clear Tokens
      if (sl.isRegistered<SocketSessionManager>()) {
        log("Cleanup: Clearing socket session via Manager...");
        await sl<SocketSessionManager>().clearSession();
        log("Cleanup: Socket session cleared.");
      } else if (sl.isRegistered<SocketService>()) {
        log("Cleanup: Disconnecting socket (fallback)...");
        final socketService = sl<SocketService>();
        await socketService.disconnect(clear: true);
        log("Cleanup: Socket disconnected and tokens cleared.");
      } else {
        await SecureStorage.clearTokens();
        log("Cleanup: Tokens cleared manually.");
      }

      if (sl.isRegistered<UserCubit>()) {
        log("Cleanup: Resetting UserCubit...");
        sl<UserCubit>().reset();
        log("Cleanup: UserCubit reset.");
      }

      if (sl.isRegistered<HomeBloc>()) {
        log("Cleanup: Resetting HomeBloc...");
        sl<HomeBloc>().add(ResetHome());
        log("Cleanup: HomeBloc reset.");
      }

      log("Cleanup: Cleanup completed successfully.");
    } catch (e) {
      log("Cleanup error: $e");
    }
  }
}
