import 'package:dating_app/core/network/http/dio_client.dart';
import 'package:dating_app/features/employee/history/cubit/session_cubit.dart';
import 'package:dating_app/features/employee/history/screen/widgets/session_item.dart';
import 'package:dating_app/features/employee/history/service/session_history.dart';
import 'package:dating_app/features/employee/home/widgets/employee_app_bar.dart';
import 'package:dating_app/features/employee/home/widgets/employee_error_view.dart';
import 'package:dating_app/features/employee/home/widgets/section_header.dart';
import 'package:dating_app/features/employee/main/cubit/navigator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class EmployeeHistoryScreen extends StatefulWidget {
  const EmployeeHistoryScreen({super.key});

  @override
  State<EmployeeHistoryScreen> createState() => _EmployeeHistoryScreenState();
}

class _EmployeeHistoryScreenState extends State<EmployeeHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SessionCubit(SessionHistory(DioClient.instance)),
      child: Builder(
        builder: (context) {
          // Listen to tab changes to trigger lazy load
          return BlocListener<EmployeeNavigatorCubit, int>(
            listener: (context, index) {
              if (index == 1) {
                _loadDataIfNeeded(context);
              }
            },
            child: GradientScaffold(
              appBar: const EmployeeAppBar(),
              body: SafeArea(
                bottom: false,
                child: BlocBuilder<SessionCubit, SessionState>(
                  builder: (context, state) {
                    if (state is SessionInitial) {
                      // If we are already visible (e.g. started on this tab or navigated),
                      // and haven't loaded, try loading if index is 1.
                      // Note: We need access to nav cubit state here.
                      final navIndex = context
                          .read<EmployeeNavigatorCubit>()
                          .state;
                      if (navIndex == 1) {
                        // Post frame to avoid build interfering
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _loadDataIfNeeded(context);
                        });
                      }
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SessionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SessionError) {
                      return EmployeeErrorView(
                        title: "Failed to Load History",
                        message: _getFriendlyErrorMessage(state.message),
                        onRetry: () {
                          context.read<SessionCubit>().fetch();
                        },
                      );
                    } else if (state is SessionLoaded) {
                      final sessions = state.sessions
                          .where((s) => s.status.toLowerCase() != 'ongoing')
                          .toList();

                      if (sessions.isEmpty) {
                        return const Center(
                          child: Text(
                            "No sessions found",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 10,
                            ),
                            child: SectionHeader(
                              title: "Session History",
                              icon: Icons.history,
                            ),
                          ),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 10,
                                bottom: 100,
                              ),
                              itemCount: sessions.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemBuilder: (context, index) {
                                final session = sessions[index];
                                final formattedDate = DateFormat(
                                  'MMM dd, yyyy - hh:mm a',
                                ).format(session.time);

                                return SessionItem(
                                  name: session.name,
                                  subtitle:
                                      "$formattedDate • ${session.duration} min • ${session.status}",
                                  imageUrl: session.avatar ?? "",
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _loadDataIfNeeded(BuildContext context) {
    if (!mounted) return;
    final cubit = context.read<SessionCubit>();
    if (cubit.state is SessionInitial || cubit.state is SessionError) {
      cubit.fetch();
    }
  }

  String _getFriendlyErrorMessage(String rawError) {
    if (rawError.toLowerCase().contains('connection') ||
        rawError.toLowerCase().contains('socket') ||
        rawError.toLowerCase().contains('host lookup')) {
      return "Unable to connect to the server. Please check your internet connection and try again.";
    } else if (rawError.contains('401')) {
      return "Session expired. Please log in again.";
    }
    return "Something went wrong. Please try again later.";
  }
}
