import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/employee/profile/cubit/employee_edit_profile_cubit.dart';
import 'package:dating_app/features/employee/profile/cubit/employee_edit_profile_state.dart';
import 'package:dating_app/features/employee/profile/screen/widgets/edit_about_field.dart';
import 'package:dating_app/features/employee/profile/screen/widgets/edit_avatar_picker.dart';
import 'package:dating_app/features/employee/profile/screen/widgets/edit_dob_picker.dart';
import 'package:dating_app/features/employee/profile/screen/widgets/edit_interest_selector.dart';
import 'package:dating_app/features/employee/profile/screen/widgets/edit_language_selector.dart';
import 'package:dating_app/features/employee/profile/screen/widgets/edit_name_field.dart';
import 'package:dating_app/features/employee/profile/screen/widgets/edit_save_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/features/employee/service/employee_service.dart';
import 'package:dating_app/di/injection.dart';

class EmployeeEditProfileScreen extends StatelessWidget {
  const EmployeeEditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = EmployeeEditProfileCubit(EmployeeService(sl()));
        cubit.loadProfile();
        return cubit;
      },
      child: BlocListener<EmployeeEditProfileCubit, EmployeeEditProfileState>(
        listener: (context, state) {
          if (state is EmployeeEditProfileUpdateSuccess) {
            showAppSnackbar(
              context,
              message: 'Profile updated successfully',
              icon: Icons.check_circle,
              backgroundColor: Colors.green,
            );
            Navigator.pop(context); // Pop screen on success
          } else if (state is EmployeeEditProfileEditing &&
              state.errorMessage != null &&
              state.errorMessage!.isNotEmpty) {
            showAppSnackbar(
              context,
              message: state.errorMessage!,
              icon: Icons.error,
            );
          }
        },
        child: GradientScaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: Colors.white),
            title: const Text(
              "Edit Profile",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SafeArea(
            child:
                BlocBuilder<EmployeeEditProfileCubit, EmployeeEditProfileState>(
                  builder: (context, state) {
                    if (state is EmployeeEditProfileEditing) {
                      return Stack(
                        children: [
                          EmployeeEditProfileForm(state: state),
                          if (state.isLoading)
                            Container(
                              color: Colors.black54,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
          ),
        ),
      ),
    );
  }
}

class EmployeeEditProfileForm extends StatelessWidget {
  final EmployeeEditProfileEditing state;

  const EmployeeEditProfileForm({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EmployeeEditProfileCubit>();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  EditAvatarPicker(
                    state: state,
                    onAvatarChanged: cubit.avatarChanged,
                  ),
                  const SizedBox(height: 30),
                  EditNameField(state: state, onChanged: cubit.nameChanged),
                  const SizedBox(height: 20),
                  EditDobPicker(state: state, onDateSelected: cubit.dobChanged),
                  const SizedBox(height: 20),
                  EditAboutField(state: state, onChanged: cubit.aboutChanged),
                  const SizedBox(height: 20),
                  EditInterestSelector(
                    state: state,
                    onInterestToggled: cubit.interestToggled,
                  ),
                  const SizedBox(height: 20),
                  EditLanguageSelector(
                    state: state,
                    onLanguageChanged: cubit.languageChanged,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: EditSaveButton(
              state: state,
              onSave: () {
                cubit.updateProfile();
              },
            ),
          ),
        ],
      ),
    );
  }
}
