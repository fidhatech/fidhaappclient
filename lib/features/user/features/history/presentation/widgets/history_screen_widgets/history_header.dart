import 'package:flutter/material.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 25),
        Text(
          'History',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
