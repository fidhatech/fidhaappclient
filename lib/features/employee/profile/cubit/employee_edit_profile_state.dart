import 'package:equatable/equatable.dart';

abstract class EmployeeEditProfileState extends Equatable {
  const EmployeeEditProfileState();

  @override
  List<Object?> get props => [];
}

class EmployeeEditProfileInitial extends EmployeeEditProfileState {}

class EmployeeEditProfileEditing extends EmployeeEditProfileState {
  final String? name;
  final String? dob;
  final String? gender;
  final String? avatarPath;
  final List<String> interests;
  final List<String> languages;
  final String? about;
  final int?
  age; // Derived from DOB usually, but API might expect it or return it
  final bool isLoading;
  final String? errorMessage;

  const EmployeeEditProfileEditing({
    this.name,
    this.dob,
    this.gender,
    this.avatarPath,
    this.interests = const [],
    this.languages = const [],
    this.about,
    this.age,
    this.isLoading = false,
    this.errorMessage,
  });

  EmployeeEditProfileEditing copyWith({
    String? name,
    String? dob,
    String? gender,
    String? avatarPath,
    List<String>? interests,
    List<String>? languages,
    String? about,
    int? age,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EmployeeEditProfileEditing(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      avatarPath: avatarPath ?? this.avatarPath,
      interests: interests ?? this.interests,
      languages: languages ?? this.languages,
      about: about ?? this.about,
      age: age ?? this.age,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    name,
    dob,
    gender,
    avatarPath,
    interests,
    languages,
    about,
    age,
    isLoading,
    errorMessage,
  ];
}

class EmployeeEditProfileUpdateSuccess extends EmployeeEditProfileState {}

class EmployeeEditProfileUpdateFailure extends EmployeeEditProfileState {
  final String error;

  const EmployeeEditProfileUpdateFailure(this.error);

  @override
  List<Object> get props => [error];
}
