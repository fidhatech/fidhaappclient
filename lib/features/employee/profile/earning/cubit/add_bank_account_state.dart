part of 'add_bank_account_cubit.dart';

abstract class AddBankAccountState extends Equatable {
  const AddBankAccountState();

  @override
  List<Object> get props => [];
}

class AddBankAccountInitial extends AddBankAccountState {}

class AddBankAccountLoading extends AddBankAccountState {}

class AddBankAccountSuccess extends AddBankAccountState {
  final String message;

  const AddBankAccountSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class AddBankAccountError extends AddBankAccountState {
  final String message;

  const AddBankAccountError(this.message);

  @override
  List<Object> get props => [message];
}
