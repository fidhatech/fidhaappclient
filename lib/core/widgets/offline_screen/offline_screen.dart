import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:flutter/material.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1) App Name / Logo Placeholder
              Text(
                "Fidha",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontFamily: 'GreatVibes',
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),

              // 2) Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // 3) Message
              Text(
                "No Internet Connection",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Please check your network settings.\nWe'll reconnect automatically.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
