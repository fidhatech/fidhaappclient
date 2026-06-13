import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../assets_gen/assets.gen.dart';
import '../../../../config/theme/app_color.dart';
import '../../../../core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/call/cubit/client_call_cubit.dart';
import '../../features/call/model/call_type.dart';
import '../../models/employee_model.dart';
import '../cubit/user_details_cubit/user_details_cubit.dart';
import '../cubit/user_details_cubit/user_details_state.dart';
import '../../features/details/presentation/widgets/header_image_slider.dart';
import '../../features/details/presentation/widgets/user_info_content.dart';
import '../../features/details/presentation/widgets/custom_back_button.dart';

part '../widgets/action_buttons_bar.dart';

@RoutePage()
class UserDetailsScreen extends StatefulWidget {

  final dynamic args;

  const UserDetailsScreen(this.args, {super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {

  final UserDetailsCubit _cubit = UserDetailsCubit();

  String _empId = '';
  EmployeeModel? _initialData;

  @override
  void initState() {
    super.initState();

    final args = widget.args;
    if (args is EmployeeModel) {
      _initialData = args;
      _empId = args.empId;
    } else if (args is String) {
      _empId = args;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_empId.isEmpty) return;

      _cubit.loadEmployee(_empId, initialData: _initialData);
    });
  }

  @override
  void dispose() {
    _cubit.close();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_empId.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No Employee ID provided')),
      );
    }

    return BlocProvider.value(
      value: _cubit,
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
                  _ActionButtonsBar(employee: state.employee),
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
