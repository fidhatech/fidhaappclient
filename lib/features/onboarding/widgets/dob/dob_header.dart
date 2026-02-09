import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/utils/mediaquery.dart';
import 'package:flutter/material.dart';

class DobHeader extends StatelessWidget {
  const DobHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColor.primaryText),
          padding: EdgeInsets.zero,
          alignment: Alignment.centerLeft,
          onPressed: () {},
        ),
        SizedBox(height: controlHeight(context, 50)),
        Text(
          'Name',
          style: TextStyle(
            fontSize: controlWidth(context, 11.5),
            fontWeight: FontWeight.bold,
            color: AppColor.primaryText,
          ),
        ),
        SizedBox(height: controlHeight(context, 100)),
        Text(
          'To get started, tell us who you are.',
          style: TextStyle(
            fontSize: controlWidth(context, 24),
            fontWeight: FontWeight.w300,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
