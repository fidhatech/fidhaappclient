import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
      onTap: () => _showOptions(context),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
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
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(Icons.edit, size: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (bottomCtx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.pop(bottomCtx);
                  await _pickImage(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.pop(bottomCtx);
                  await _pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.face),
                title: const Text('Choose Avatar'),
                onTap: () {
                  Navigator.pop(bottomCtx);
                  _showAvatarDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: source, imageQuality: 85);
    if (file != null) {
      onAvatarChanged(file.path);
    }
  }

  void _showAvatarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
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
                Navigator.pop(dialogCtx);
              },
            ),
          ),
        ),
      ),
    );
  }
}
