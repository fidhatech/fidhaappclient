import 'package:equatable/equatable.dart';

abstract class EmployeeLanguageState extends Equatable {
  const EmployeeLanguageState();

  @override
  List<Object> get props => [];
}

class EmployeeLanguageInitial extends EmployeeLanguageState {}

class LanguageLoaded extends EmployeeLanguageState {
  final List<String> languages;
  const LanguageLoaded(this.languages);
}

class EmployeeLanguageSelected extends EmployeeLanguageState {
  final String language;

  const EmployeeLanguageSelected(this.language);

  @override
  List<Object> get props => [language];
}

class EmployeeLanguageLoading extends EmployeeLanguageState {}

class EmployeeLanguageSubmitting extends EmployeeLanguageState {}

class EmployeeLanguageSuccess extends EmployeeLanguageState {
  final String language;
  final String textToRead;

  const EmployeeLanguageSuccess({
    required this.language,
    required this.textToRead,
  });

  @override
  List<Object> get props => [language, textToRead];
}

class EmployeeLanguageError extends EmployeeLanguageState {
  final String message;

  const EmployeeLanguageError(this.message);

  @override
  List<Object> get props => [message];
}
