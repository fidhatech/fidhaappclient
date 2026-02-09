import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/utils/url_helper.dart';
import 'package:flutter/material.dart';

class EmployeeTerms extends StatelessWidget {
  const EmployeeTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => UrlHelper.launchURL(AppUrls.termsAndConditions),
        child: Text(
          "Terms and Conditions Terms and Conditions",
          style: TextStyle(
            color: Colors.grey.withValues(alpha: 0.5),
            fontSize: 12,
            decoration: TextDecoration.underline,
            decorationColor: Colors.grey.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
