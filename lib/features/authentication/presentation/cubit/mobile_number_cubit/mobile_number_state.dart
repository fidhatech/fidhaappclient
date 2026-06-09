import 'package:equatable/equatable.dart';

abstract class MobileNumberState extends Equatable {
  const MobileNumberState();
}

class MobileNumberInitial extends MobileNumberState {
  final String mobileNumber;
  final bool isValid;

  const MobileNumberInitial({this.mobileNumber = "", this.isValid = false});

  MobileNumberInitial copyWith({String? mobileNumber, bool? isValid}) {
    return MobileNumberInitial(
      mobileNumber: mobileNumber ?? this.mobileNumber,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [mobileNumber, isValid];
}
