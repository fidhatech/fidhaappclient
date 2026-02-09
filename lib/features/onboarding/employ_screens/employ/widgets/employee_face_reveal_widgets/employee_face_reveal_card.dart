import 'dart:io';
import 'package:flutter/material.dart';

/// A card widget representing a single slot in the Face Reveal grid.
///
/// Displays the selected image if [imagePath] is provided, or an 'add' icon otherwise.
/// Tapping the card triggers the [onTap] callback.
class EmployeeFaceRevealCard extends StatelessWidget {
  /// The path to the image file to display. If null, a placeholder is shown.
  final String? imagePath;

  /// Callback triggered when the card is tapped.
  final VoidCallback onTap;

  const EmployeeFaceRevealCard({
    super.key,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          image: hasImage
              ? DecorationImage(
                  image: ResizeImage(
                    FileImage(File(imagePath!)),
                    width: 350,
                    policy: ResizeImagePolicy.fit,
                  ),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: !hasImage
            ? const Center(
                child: Icon(Icons.add, color: Colors.white, size: 32),
              )
            : null,
      ),
    );
  }
}
