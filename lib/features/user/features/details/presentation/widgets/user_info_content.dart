import 'package:flutter/material.dart';
import 'package:dating_app/config/theme/app_color.dart';
import '../../../../models/employee_model.dart';
import 'name_header.dart';
import 'languages_section.dart';
import 'interests_wrap.dart';

class UserInfoContent extends StatelessWidget {
  final EmployeeModel employee;

  const UserInfoContent({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NameHeader(name: employee.name),
          const SizedBox(height: 5),
          LanguagesSection(languages: employee.language ?? []),

          const SizedBox(height: 15),
          const Text(
            "Interests",
            style: TextStyle(
              color: AppColor.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          InterestsWrap(interests: employee.interests),
          const SizedBox(height: 15),
          if (employee.about != null && employee.about!.isNotEmpty) ...[
            const Text(
              "About",
              style: TextStyle(
                color: AppColor.primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              employee.about!,
              style: const TextStyle(
                color: AppColor.secondaryText,
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
