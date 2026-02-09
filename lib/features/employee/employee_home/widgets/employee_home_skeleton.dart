import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EmployeeHomeSkeleton extends StatelessWidget {
  const EmployeeHomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white24,
      highlightColor: Colors.white54,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Call Settings Header Placeholder
                Row(
                  children: [
                    Container(width: 24, height: 24, color: Colors.white),
                    const SizedBox(width: 8),
                    Container(width: 150, height: 20, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 16),
                // Call Control Panel Placeholder
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Your Rewards Header Placeholder
                Row(
                  children: [
                    Container(width: 24, height: 24, color: Colors.white),
                    const SizedBox(width: 8),
                    Container(width: 150, height: 20, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 16),
                // Earnings Section Placeholder
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
