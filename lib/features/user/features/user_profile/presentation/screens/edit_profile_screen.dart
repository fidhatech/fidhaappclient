import 'dart:io';

import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/core/widgets/loading_dialog/otp_loading_dialog.dart';
import 'package:dating_app/features/onboarding/widgets/gender_selection_screen_widgets/gender_avatar_selector.dart';
import 'package:dating_app/features/onboarding/widgets/onboarding_content/onboarding_action_button.dart';
import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:dating_app/features/user/features/user_profile/cubit/profile_cubit.dart';
import 'package:dating_app/features/user/features/user_profile/presentation/widget/edit_profile_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: _onProfileStateChange,
      child: GradientScaffold(
        appBar: _buildAppBar(),
        body: SafeArea(child: const _EditProfileBody()),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const BackButton(color: Colors.white),
      title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
    );
  }

  void _onProfileStateChange(BuildContext context, ProfileState state) {
    if (state is ProfileUpdateSuccess) {
      context.read<UserCubit>().fetchUser();
      showAppSnackbar(
        context,
        message: 'Profile updated successfully',
        icon: Icons.check_circle,
        backgroundColor: Colors.green,
      );
      Navigator.pop(context);
    } else if (state is ProfileUpdateFailure) {
      showAppSnackbar(context, message: state.error, icon: Icons.error);
    }
  }
}

class _EditProfileBody extends StatefulWidget {
  const _EditProfileBody();

  @override
  State<_EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<_EditProfileBody> {
  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  void _initializeProfile() {
    final userState = context.read<UserCubit>().state;
    if (userState is UserLoaded) {
      final user = userState.userModel;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ProfileCubit>().loadProfileForEditing(user.gender);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileInitial || state is EditProfileLoading) {
          return const Center(child: ThreeDotsLoading());
        }

        if (state is ProfileEditing) {
          return Stack(
            children: [
              _EditProfileFormContent(state: state),
              if (state.isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(child: ThreeDotsLoading()),
                ),
            ],
          );
        }

        return const Center(child: ThreeDotsLoading());
      },
    );
  }
}

class _EditProfileFormContent extends StatelessWidget {
  final ProfileEditing state;

  const _EditProfileFormContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProfileCubit>();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _AvatarSection(state: state, cubit: cubit),
                  const SizedBox(height: 30),
                  EditProfileTextField(
                    label: "Name",
                    initialValue: state.name ?? '',
                    onChanged: cubit.nameChanged,
                    icon: Icons.person,
                    errorText: state.errorMessage,
                  ),
                  const SizedBox(height: 20),
                  _DatePickerField(state: state, cubit: cubit),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: OnboardingActionButton(
              text: "Save Changes",
              onPressed: cubit.updateProfile,
              backgroundColor: AppColor.primaryButton,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final ProfileEditing state;
  final ProfileCubit cubit;

  const _AvatarSection({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAvatarPicker(context),
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        backgroundImage: _getAvatarImage(state.avatarPath),
        child: _shouldShowCameraIcon(state.avatarPath)
            ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
            : null,
      ),
    );
  }

  ImageProvider? _getAvatarImage(String? path) {
    if (path != null && path.isNotEmpty) {
      return path.startsWith('http')
          ? NetworkImage(path)
          : FileImage(File(path)) as ImageProvider;
    }
    return null;
  }

  bool _shouldShowCameraIcon(String? path) {
    return path == null || path.isEmpty;
  }

  void _showAvatarPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D001A),
        title: const Text(
          'Select Avatar',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: GenderAvatarSelector(
              gender: state.gender ?? 'Male',
              selectedAvatar: state.avatarPath,
              onAvatarSelected: (avatar) {
                cubit.avatarChanged(avatar);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final ProfileEditing state;
  final ProfileCubit cubit;

  const _DatePickerField({required this.state, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          final formattedDate =
              "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
          cubit.dobChanged(formattedDate);
        }
      },
      child: AbsorbPointer(
        child: EditProfileTextField(
          label: "Date of Birth",
          initialValue: state.dob ?? '',
          onChanged: (_) {},
          icon: Icons.calendar_today,
          key: ValueKey(state.dob),
        ),
      ),
    );
  }
}
