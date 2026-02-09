import 'dart:developer';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/employee/home/cubit/employee_cubit.dart';
import 'package:dating_app/features/employee/home/widgets/employee_app_bar.dart';
import 'package:dating_app/features/employee/employee_home/widgets/employee_home_skeleton.dart';
import 'package:dating_app/features/employee/employee_home/widgets/employee_home_content.dart';
import 'package:dating_app/features/employee/home/screens/offline_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  @override
  void initState() {
    super.initState();
    log("EmployeeHomeScreen: initState called");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'Retry',
                textColor: Colors.white,
                onPressed: () {
                  context.read<EmployeeCubit>().retry();
                },
              ),
            ),
          );
        }
      },
      child: BlocBuilder<EmployeeCubit, EmployeeState>(
        builder: (context, state) {
          log(
            "EmployeeHomeScreen: BlocBuilder rebuilding with state: ${state.runtimeType}",
          );
          if (state is EmployeeSuccess) {
            log(
              "EmployeeHomeScreen: Success data: Earnings=${state.employee.todayEarning}, Calls=${state.employee.totalCalls}",
            );
          }
          return GradientScaffold(
            appBar: const EmployeeAppBar(),
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (state is EmployeeLoading) {
                          return const EmployeeHomeSkeleton();
                        } else if (state is EmployeeOffline) {
                          return const EmployeeOfflineScreen();
                        } else if (state is EmployeeFailure) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.white54,
                                  size: 48,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Unable to load data",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    context.read<EmployeeCubit>().retry();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text("Retry"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white24,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (state is EmployeeSuccess) {
                          return EmployeeHomeContent(employee: state.employee);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
