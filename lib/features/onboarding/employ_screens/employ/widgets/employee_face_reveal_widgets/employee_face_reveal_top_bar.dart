import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/employee_face_reveal_cubit/employee_face_reveal_cubit.dart';

/// Top bar widget displaying navigation actions, such as 'Skip'.
class EmployeeFaceRevealTopBar extends StatelessWidget {
  const EmployeeFaceRevealTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            context.read<EmployeeFaceRevealCubit>().skip();
          },
          child: const Text(
            'Skip',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
