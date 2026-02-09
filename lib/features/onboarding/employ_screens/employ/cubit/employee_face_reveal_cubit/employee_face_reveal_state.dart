import 'package:equatable/equatable.dart';

/// Base state for [EmployeeFaceRevealCubit].
abstract class EmployeeFaceRevealState extends Equatable {
  const EmployeeFaceRevealState();

  @override
  List<Object> get props => [];
}

/// Initial state when the screen is first loaded.
class EmployeeFaceRevealInitial extends EmployeeFaceRevealState {}

/// State emitted when the list of media files is updated.
class EmployeeFaceRevealUpdated extends EmployeeFaceRevealState {
  /// The list of selected media files.
  ///
  /// Contains 4 slots, where each slot can be a file path [String] or null.
  final List<String?> mediaFiles;

  const EmployeeFaceRevealUpdated({this.mediaFiles = const []});

  @override
  List<Object> get props => [mediaFiles];
}
