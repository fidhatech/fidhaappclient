part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class EditProfileLoading extends ProfileState {}

class LogoutSuccess extends ProfileState {}

class LogoutFailure extends ProfileState {
  final String error;
  LogoutFailure(this.error);
}

class DeleteAccountSuccess extends ProfileState {}

class DeleteAccountFailure extends ProfileState {
  final String error;
  DeleteAccountFailure(this.error);
}

class ProfileUpdateSuccess extends ProfileState {}

class ProfileUpdateFailure extends ProfileState {
  final String error;
  ProfileUpdateFailure(this.error);
}

class ProfileEditing extends ProfileState {
  final String? name;
  final String? dob;
  final String? avatarPath;
  final String? about;
  final String? gender;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  ProfileEditing({
    this.name,
    this.dob,
    this.avatarPath,
    this.about,
    this.gender,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  ProfileEditing copyWith({
    String? name,
    String? dob,
    String? avatarPath,
    String? about,
    String? gender,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return ProfileEditing(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      avatarPath: avatarPath ?? this.avatarPath,
      about: about ?? this.about,
      gender: gender ?? this.gender,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
