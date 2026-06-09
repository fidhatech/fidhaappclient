import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:dating_app/core/utils/url_helper.dart';
import 'package:flutter/material.dart';

class GenderTermsText extends StatelessWidget {
  const GenderTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => UrlHelper.launchURL(AppUrls.termsAndConditions),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              color: Colors.white54,
              fontSize: controlWidth(context, 34),
              decoration: TextDecoration.underline,
              decorationColor: Colors.white54,
            ),
            children: const [
              TextSpan(text: 'Terms and Conditions '),
              TextSpan(text: 'Terms and\n'),
              TextSpan(text: 'Conditions '),
            ],
          ),
        ),
      ),
    );
  }
}
