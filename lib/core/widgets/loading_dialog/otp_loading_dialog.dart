import 'package:dating_app/config/theme/app_color.dart';
import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (_) => const _ThreeDotLoadingDialog(),
  );
}

class _ThreeDotLoadingDialog extends StatelessWidget {
  const _ThreeDotLoadingDialog();

  @override
  Widget build(BuildContext context) {
    return const Center(child: ThreeDotsLoading());
  }
}

class ThreeDotsLoading extends StatefulWidget {
  const ThreeDotsLoading({super.key});

  @override
  State<ThreeDotsLoading> createState() => _ThreeDotsLoadingState();
}

class _ThreeDotsLoadingState extends State<ThreeDotsLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim1;
  late Animation<double> _anim2;
  late Animation<double> _anim3;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1000,
      ), // Slightly slower for elegance
    )..repeat(reverse: true);

    _anim1 = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
    _anim2 = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.75, curve: Curves.easeInOut),
      ),
    );
    _anim3 = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Create a wave effect by reversing the scale calculation
        // This is a simple way to make them pulse up and down in sequence
        // Actually, the Interval logic above already handles the sequencing.
        // We just need to handle the "ping-pong" effect or reset.
        // The Interval 0.0-0.5 means it goes 0.4->1.0 in the first half.
        // But we want it to go up and come back down?
        // Let's stick to the ScaleTransition logic but make it loop smoother or use a Sine wave.

        // Better: Just use Sin wave for continuous smooth pulsing
        double value = animation.value;
        // The Interval provides a 0.0 -> 1.0 value.
        // We want 0.4 -> 1.0 -> 0.4?
        // For simple repeating controller, it goes 0->1 then resets to 0.
        // So with Interval, it ramps up.
        // Let's make it simpler and reliable: just use the controller value with a phase shift.

        return Transform.scale(
          scale: value,
          child: Container(
            width: 12, // Slightly larger
            height: 12,
            decoration: BoxDecoration(
              color: AppColor.primaryButton, // Pink accent
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColor.primaryButton.withValues(alpha: 0.6 * value),
                  blurRadius: 8 * value,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Re-implementing _dot to be simpler with the existing animation setup which was doing a repeat.
  // The previous setup was Repeat, so it ramps 0->1, 0->1.
  // The Curves.animate with Interval makes it stay at begin/end outside the interval.
  // To make it pulse (up AND down), we usually use reverse: true in repeat().

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _dot(_anim1),
        const SizedBox(width: 10), // More spacing
        _dot(_anim2),
        const SizedBox(width: 10),
        _dot(_anim3),
      ],
    );
  }
}
