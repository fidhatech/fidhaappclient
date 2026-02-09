import 'package:equatable/equatable.dart';

abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object> get props => [];
}

class FilterInitial extends FilterState {}

class FilterLoading extends FilterState {}

class FilterLoaded extends FilterState {
  final List<String> availableLanguages;
  final List<String> selectedLanguages;

  const FilterLoaded({
    required this.availableLanguages,
    required this.selectedLanguages,
  });

  @override
  List<Object> get props => [availableLanguages, selectedLanguages];

  FilterLoaded copyWith({
    List<String>? availableLanguages,
    List<String>? selectedLanguages,
  }) {
    return FilterLoaded(
      availableLanguages: availableLanguages ?? this.availableLanguages,
      selectedLanguages: selectedLanguages ?? this.selectedLanguages,
    );
  }
}

class FilterError extends FilterState {
  final String message;

  const FilterError(this.message);

  @override
  List<Object> get props => [message];
}
