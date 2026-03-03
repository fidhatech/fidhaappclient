import 'package:bloc/bloc.dart';
import 'package:dating_app/features/employee/profile/earning/service/bank_service.dart';
import 'package:equatable/equatable.dart';

part 'add_bank_account_state.dart';

class AddBankAccountCubit extends Cubit<AddBankAccountState> {
  final BankService _bankService;

  AddBankAccountCubit({required BankService bankService})
    : _bankService = bankService,
      super(AddBankAccountInitial());

  Future<void> submitBankDetails({
    required String accountHolderName,
    required String bankName,
    required String accountNumber,
    required String ifscCode,
  }) async {
    emit(AddBankAccountLoading());
    try {
      await _bankService.submitBankDetails(
        accountHolderName: accountHolderName,
        bankName: bankName,
        accountNumber: accountNumber,
        ifscCode: ifscCode,
      );
      emit(const AddBankAccountSuccess("Bank details added successfully"));
    } catch (e) {
      emit(AddBankAccountError(e.toString()));
    }
  }
}
