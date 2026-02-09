import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/widgets/employee_info_widgets/employee_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_info_cubit/employee_info_cubit.dart';

class EmployeeInfoScreen extends StatefulWidget {
  const EmployeeInfoScreen({super.key});

  @override
  State<EmployeeInfoScreen> createState() => _EmployeeInfoScreenState();
}

class _EmployeeInfoScreenState extends State<EmployeeInfoScreen> {
  late final TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _aboutController = TextEditingController();
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      resizeToAvoidBottomInset: false,
      body: RepaintBoundary(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top,
            bottom: MediaQuery.paddingOf(context).bottom,
          ),
          child: EmployeeScreenBody(
            aboutController: _aboutController,
            onConfirm: () {
              final about = _aboutController.text.trim();
              context.read<EmployeeInfoCubit>().submit(about, context);
            },
          ),
        ),
      ),
    );
  }
}
