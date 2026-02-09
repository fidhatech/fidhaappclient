import 'package:dating_app/features/employee/home/cubit/employee_cubit.dart';
import 'package:dating_app/features/employee/home/widgets/call_control_panel.dart';
import 'package:dating_app/features/employee/home/widgets/earnings_section.dart';
import 'package:dating_app/features/employee/home/widgets/section_header.dart';
import 'package:dating_app/features/employee/model/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeHomeContent extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeHomeContent({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const SectionHeader(
                title: 'Call Settings',
                icon: Icons.phone_callback,
              ),
              const SizedBox(height: 16),
              CallControlPanel(
                isAudioEnabled: employee.isAudioEnabled,
                isVideoEnabled: employee.isVideoEnabled,
                audioRate: employee.audioRatePerMin,
                videoRate: employee.videoRatePerMin,
                onToggleAudio: (val) {
                  context.read<EmployeeCubit>().updateCallPreference(
                    isAudioEnabled: val,
                  );
                },
                onToggleVideo: (val) {
                  context.read<EmployeeCubit>().updateCallPreference(
                    isVideoEnabled: val,
                  );
                },
              ),
              const SizedBox(height: 32),
              const SectionHeader(
                title: 'Your Rewards',
                icon: Icons.monetization_on_outlined,
              ),
              const SizedBox(height: 16),
              EarningsSection(
                todayEarnings: '${employee.todayEarning}',
                lifetimeEarnings: '${employee.totalEarning}',
                totalCalls: employee.totalCalls,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
