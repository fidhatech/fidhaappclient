import 'package:flutter/material.dart';

class CallToggleButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int priceIdx;
  final bool isActive;

  final VoidCallback onTap;

  const CallToggleButton({
    super.key,
    required this.icon,
    required this.label,
    required this.priceIdx,
    required this.isActive,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.greenAccent.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive
                ? Colors.greenAccent.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.1),
            width: 2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.greenAccent.withValues(alpha: 0.1),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.greenAccent.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isActive ? Colors.greenAccent : Colors.white24,
                    size: 24,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.greenAccent.withValues(alpha: 0.2)
                        : Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isActive ? 'ON' : 'OFF',
                    style: TextStyle(
                      color: isActive ? Colors.greenAccent : Colors.white24,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white38,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                isActive ? 'Enabled' : 'Disabled',
                style: TextStyle(
                  color: isActive
                      ? Colors.greenAccent.withValues(alpha: 0.7)
                      : Colors.white24,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive
                      ? Colors.greenAccent.withValues(alpha: 0.2)
                      : Colors.white10,
                ),
              ),
              child: Center(
                child: Text(
                  '₹$priceIdx / min',
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.white24,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
