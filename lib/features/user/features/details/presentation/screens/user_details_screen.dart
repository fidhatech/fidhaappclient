import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dating_app/di/injection.dart';
import '../../../../models/employee_model.dart';
import '../cubit/user_details_cubit.dart';
import '../cubit/user_details_state.dart';
import '../widgets/header_image_slider.dart';
import '../widgets/user_info_content.dart';
import '../widgets/action_buttons_bar.dart';
import '../widgets/custom_back_button.dart';

class UserDetailsScreen extends StatelessWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    String empId = '';
    EmployeeModel? initialData;

    if (args is EmployeeModel) {
      initialData = args;
      empId = args.empId;
    } else if (args is String) {
      empId = args;
    }

    if (empId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No Employee ID provided")),
      );
    }

    return BlocProvider(
      create: (context) =>
          sl<UserDetailsCubit>()..loadEmployee(empId, initialData: initialData),
      child: GradientScaffold(
        body: BlocBuilder<UserDetailsCubit, UserDetailsState>(
          builder: (context, state) {
            if (state is UserDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserDetailsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is UserDetailsLoaded) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderImageSlider(
                          employee: state.employee,
                          currentImageIndex: state.currentImageIndex,
                        ),
                        UserInfoContent(employee: state.employee),
                      ],
                    ),
                  ),
                  ActionButtonsBar(employee: state.employee),
                  const CustomBackButton(),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
