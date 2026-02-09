import 'package:dating_app/features/user/features/details/repository/user_details_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/employee_model.dart';
import 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
  final UserDetailsRepository _repository;

  UserDetailsCubit({UserDetailsRepository? repository})
    : _repository = repository ?? UserDetailsRepository(),
      super(UserDetailsInitial());

  Future<void> loadEmployee(String empId, {EmployeeModel? initialData}) async {
    if (initialData != null) {}

    emit(UserDetailsLoading());
    try {
      final employee = await _repository.getEmployeeDetails(empId);
      if (isClosed) return;
      emit(UserDetailsLoaded(employee: employee));
    } catch (e) {
      if (isClosed) return;
      if (initialData != null) {
        emit(UserDetailsLoaded(employee: initialData));
      } else {
        emit(UserDetailsError(e.toString()));
      }
    }
  }

  void updateImageIndex(int index) {
    if (state is UserDetailsLoaded) {
      emit((state as UserDetailsLoaded).copyWith(currentImageIndex: index));
    }
  }
}
