import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dating_app/features/employee/profile/cubit/employee_edit_profile_state.dart';
import 'package:dating_app/features/onboarding/widgets/gender_selection_screen_widgets/gender_avatar_selector.dart';

class EditAvatarPicker extends StatelessWidget {
  final EmployeeEditProfileEditing state;
  final Function(String) onAvatarChanged;

  const EditAvatarPicker({
    super.key,
    required this.state,
    required this.onAvatarChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
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
                  gender: state.gender ?? 'Female',
                  selectedAvatar: state.avatarPath,
                  onAvatarSelected: (avatar) {
                    onAvatarChanged(avatar);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        );
      },
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        backgroundImage:
            state.avatarPath != null && state.avatarPath!.isNotEmpty
            ? (state.avatarPath!.startsWith('http')
                  ? NetworkImage(state.avatarPath!)
                  : FileImage(File(state.avatarPath!)) as ImageProvider)
            : null,
        child: (state.avatarPath == null || state.avatarPath!.isEmpty)
            ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
            : null,
      ),
    );
  }
}
