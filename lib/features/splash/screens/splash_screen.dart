import 'dart:async';
import 'dart:developer';
import 'package:dating_app/core/app/app_start_decider.dart';
import 'package:dating_app/features/employee/main/employee_scope.dart';
import 'package:dating_app/features/splash/presentation/cubit/app_start_cubit.dart';
import 'package:dating_app/features/onboarding/screens/join_community_screen.dart';
import 'package:dating_app/features/splash/widgets/splash_background.dart';
import 'package:dating_app/features/splash/widgets/splash_content.dart';
import 'package:dating_app/features/user/features/navigation/user_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _iconPopAnim;
  late Animation<double> _textFadeAnim;
  late Animation<Offset> _textSlideAnim;

  late AppStartCubit _cubit;
  final Completer<void> _animationCompleter = Completer<void>();

  @override
  void initState() {
    super.initState();
    _cubit = AppStartCubit()..checkAppStart();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _iconPopAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _textFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _textSlideAnim =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.5, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward().whenComplete(() {
      _animationCompleter.complete();
    });
  }

  Future<void> _handleNavigation(
    BuildContext context,
    AppStartStatus status,
  ) async {
    if (!_animationCompleter.isCompleted) {
      await _animationCompleter.future;
    }

    if (!mounted) return;

    if (!mounted) return;

    log("[APP_START] Navigating to: $status");

    if (status == AppStartStatus.employee) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => EmployeeScope()),
        (route) => false,
      );
    } else if (status == AppStartStatus.client) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => UserScope()),
        (route) => false,
      );
    } else {
      Navigator.pushReplacement(
        context,
        _createRoute(const JoinCommunityScreen()),
      );
    }
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.fastOutSlowIn;

        var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
        var scaleTween = Tween(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<AppStartCubit, AppStartState>(
        listener: (context, state) {
          if (state.status == AppStartStatusState.determined &&
              state.target != null) {
            _handleNavigation(context, state.target!);
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              const SplashBackground(),
              Center(
                child: SplashContent(
                  iconPopAnim: _iconPopAnim,
                  textFadeAnim: _textFadeAnim,
                  textSlideAnim: _textSlideAnim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
