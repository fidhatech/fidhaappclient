import 'package:flutter/material.dart';

class FilterSectionTitle extends StatelessWidget {
  final String title;
  const FilterSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
