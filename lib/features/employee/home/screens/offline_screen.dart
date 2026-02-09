import 'package:dating_app/core/services/socket_session_manager.dart';
import 'package:dating_app/di/injection.dart';
import 'package:flutter/material.dart';

class EmployeeOfflineScreen extends StatelessWidget {
  const EmployeeOfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Colors.white54, size: 80),
            const SizedBox(height: 20),
            const Text(
              'No Connection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please check your internet connection\nand try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const SizedBox(height: 30),
            FilledButton.icon(
              onPressed: () {
                // Manually trigger reconnect check via Manager
                sl<SocketSessionManager>().checkAndReconnect();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(
                  0xFFFF4D6D,
                ), // Use app accent color
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
