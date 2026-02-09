import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dating_app/config/theme/app_color.dart';
import '../../../../models/employee_model.dart';
import '../cubit/user_details_cubit.dart';

class HeaderImageSlider extends StatelessWidget {
  final EmployeeModel employee;
  final int currentImageIndex;

  const HeaderImageSlider({
    super.key,
    required this.employee,
    required this.currentImageIndex,
  });

  @override
  Widget build(BuildContext context) {
    final images =
        employee.profileImages != null && employee.profileImages!.isNotEmpty
        ? employee.profileImages!
        : [employee.avatar];

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            onPageChanged: (index) {
              context.read<UserDetailsCubit>().updateImageIndex(index);
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: images[index] ?? "",
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColor.secondaryText,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) {
                  return Container(
                    color: AppColor.secondaryText,
                    child: const Center(
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white54,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: index == currentImageIndex ? 20 : 8,
                  height: 4,
                  decoration: BoxDecoration(
                    color: index == currentImageIndex
                        ? AppColor.primaryText
                        : AppColor.primaryText.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 70,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColor.secondary.withValues(alpha: 0.5),
                    AppColor.secondary,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
