import 'dart:developer';

import '../../../../di/injection.dart';
import '../cubit/navigator_cubit.dart';
import '../../session/cubit/employee_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/emp_bottom_nav_bar.dart';
import '../../employee_home/screen/employee_home_wrapper.dart';
import '../../history/screen/history_screen.dart';
import '../../profile/screen/account_screen.dart';
import '../../../../core/widgets/socket/socket_error_listener.dart';
import '../../../../core/widgets/animations/animated_indexed_stack.dart';

/// Main home screen that manages tab navigation using BLoC pattern
class EmployeeMainScreen extends StatefulWidget {
  const EmployeeMainScreen({super.key});

  @override
  State<EmployeeMainScreen> createState() => _EmployeeMainScreenState();
}

class _EmployeeMainScreenState extends State<EmployeeMainScreen> {
  late EmployeeNavigatorCubit _navCubit;

  @override
  void initState() {
    super.initState();
    _navCubit = sl<EmployeeNavigatorCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider.value(value: _navCubit)],
      child: BlocBuilder<EmployeeNavigatorCubit, int>(
        builder: (context, state) {
          return SocketErrorListener(
            onRetry: () {
              context.read<EmployeeSessionCubit>().initialize();
            },
            child: Scaffold(
              extendBody: true,
              body: AnimatedIndexedStack(
                index: state,
                children: [
                  const EmployeeHomeWrapper(),
                  const EmployeeHistoryScreen(),
                  const EmployeeAccountScreen(),
                ],
              ),
              bottomNavigationBar: EmployeeCustomBottomNavBar(
                selectedIndex: _navCubit.state,
                onTabChange: (index) {
                  log("index $index");
                  _navCubit.changePage(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
