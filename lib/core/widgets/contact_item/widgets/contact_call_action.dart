import 'package:flutter/material.dart';

class ContactCallAction extends StatelessWidget {
  final IconData icon;
  final int? rate;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const ContactCallAction({
    super.key,
    required this.icon,
    required this.rate,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isActive ? 0.15 : 0.05),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: color.withValues(alpha: isActive ? 0.4 : 0.1),
                  width: 1.5,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.1),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                icon,
                color: isActive ? color : Colors.white24,
                size: 24,
              ),
            ),
          ),
        ),
        if (rate != null) ...[
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.monetization_on_rounded,
                size: 10,
                color: Colors.amberAccent.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 2),
              Text(
                '$rate/min',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
