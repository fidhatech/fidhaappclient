import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/constants/avatar_constants.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';

class GenderAvatarSelector extends StatelessWidget {
  final String? gender;
  final String? selectedAvatar;
  final Function(String) onAvatarSelected;

  const GenderAvatarSelector({
    super.key,
    required this.gender,
    required this.selectedAvatar,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (gender == null) return const SizedBox.shrink();

    final avatars = gender == 'Male'
        ? AvatarConstants.maleAvatars
        : AvatarConstants.femaleAvatars;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: controlHeight(context, 40)),
      child: Wrap(
        spacing: controlWidth(context, 20),
        runSpacing: controlHeight(context, 40),
        alignment: WrapAlignment.center,
        children: avatars.map((url) {
          final isSelected = selectedAvatar == url;
          return GestureDetector(
            onTap: () => onAvatarSelected(url),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColor.highlightColor
                      : Colors.transparent,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: SizedBox(
                  width: controlWidth(context, 4.5),
                  height: controlWidth(context, 4.5),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    memCacheWidth: 400,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[800],
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColor.highlightColor,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[800],
                      child: const Icon(Icons.error, color: Colors.white),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
