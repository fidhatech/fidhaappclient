// import 'package:bloc/bloc.dart';
// import 'package:flutter/material.dart';
// import 'employee_info_state.dart';

// class EmployeeInfoCubit extends Cubit<EmployeeInfoState> {
//   EmployeeInfoCubit() : super(EmployeeInfoInitial());

//   final List<String> _selectedInterests = [];

//   void toggleInterest(String interest) {
//     if (_selectedInterests.contains(interest)) {
//       _selectedInterests.remove(interest);
//     } else {
//       _selectedInterests.add(interest);
//     }
//     emit(EmployeeInfoUpdated(selectedInterests: List.from(_selectedInterests)));
//   }

//   void submit(String age, String about, BuildContext context) {
//     if (age.isEmpty || about.isEmpty || _selectedInterests.isEmpty) {
//       // Ideally trigger a state change or show snackbar via listener.
//       // For simplicity in this step, I'll log or we can assume the UI handles validation.
//       // But 'complete it' implies working.
//       // I'll emit an error state? I don't have Error state.
//       // I will just print for now or use a callback?
//       // Better: Add a method to show snackbar in the screen.
//       return;
//     }
//     // Proceed with submission
//     print(
//       "Submitting: Age: $age, About: $about, Interests: $_selectedInterests",
//     );
//   }
// }
