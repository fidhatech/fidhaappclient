import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionAlert extends StatelessWidget {
  final String title;
  final String content;

  const PermissionAlert({
    super.key,
    this.title = 'Permission Required',
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await openAppSettings();
          },
          child: const Text('Allow'),
        ),
      ],
    );
  }
}
