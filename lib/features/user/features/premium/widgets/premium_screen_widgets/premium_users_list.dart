import 'package:dating_app/features/user/features/premium/model/premium_response_model.dart';
import 'package:dating_app/features/user/features/premium/widgets/premium_profile_avatar.dart';
import 'package:flutter/material.dart';

class PremiumUsersList extends StatelessWidget {
  final PremiumEmployeesResponse response;

  const PremiumUsersList({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: response.employees.length,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          final user = response.employees[index];
          return PremiumProfileAvatar(
            name: user.name,
            imageUrl: user.avatar ?? "",
          );
        },
      ),
    );
  }
}
