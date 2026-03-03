import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/core/constants/app_urls.dart';
import 'package:dating_app/core/routes/app_routes.dart';
import 'package:dating_app/core/widgets/app_snackBar/show_snackbar.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/core/widgets/loading_dialog/otp_loading_dialog.dart';
import 'package:dating_app/core/widgets/profile_dialogs/profile_dialogs.dart';
import 'package:dating_app/di/injection.dart';

import 'package:dating_app/features/employee/call/cubit/employee_call_cubit.dart';
import 'package:dating_app/features/employee/home/cubit/employee_cubit.dart';
import 'package:dating_app/features/employee/profile/cubit/employee_account_cubit.dart';
import 'package:dating_app/features/employee/profile/earning/screen/earning_screen.dart';
import 'package:dating_app/features/employee/profile/screen/safety_support_screen.dart';
import 'package:dating_app/features/employee/profile/screen/edit_profile_screen.dart';
import 'package:dating_app/features/employee/profile/screen/widgets/profile_header.dart';
import 'package:dating_app/features/employee/profile/screen/widgets/profile_option_tile.dart';
import 'package:dating_app/features/employee/service/employee_service.dart';
import 'package:dating_app/features/employee/session/cubit/employee_session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployeeAccountScreen extends StatelessWidget {
  const EmployeeAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EmployeeAccountCubit(employeeService: EmployeeService(sl())),
      child: BlocListener<EmployeeAccountCubit, EmployeeAccountState>(
        listener: (context, state) async {
          _handleAccountStateChanges(context, state);
        },
        child: Builder(
          builder: (innerContext) {
            return GradientScaffold(
              appBar: _buildAppBar(innerContext),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      _buildProfileHeader(innerContext),
                      const SizedBox(height: 40),
                      _buildOptionsList(innerContext),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "My Profile",
          style: TextStyle(color: Colors.white, fontSize: 26),
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        TextButton.icon(
          label: const Text("Edit", style: TextStyle(color: Colors.white)),
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EmployeeEditProfileScreen(),
              ),
            );

            if (context.mounted) {
              context.read<EmployeeCubit>().loadHomeData();
            }
          },
        ),
      ],
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return BlocBuilder<EmployeeSessionCubit, EmployeeSessionState>(
      builder: (context, state) {
        String name = "Employee";
        String? avatarUrl;

        if (state is EmployeeSessionLoaded) {
          name = state.employee.name;
          if (state.employee.avatar.isNotEmpty) {
            avatarUrl = state.employee.avatar.first;
          }
        }

        return ProfileHeader(name: name, avatarUrl: avatarUrl);
      },
    );
  }

  Widget _buildOptionsList(BuildContext context) {
    return Column(
      children: [
        ProfileOptionTile(
          icon: Icons.wallet_giftcard,
          title: "Earnings",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EarningScreen()),
            );
          },
        ),
        // const SizedBox(height: 10),
        // ProfileOptionTile(
        //   icon: Icons.help_outline,
        //   title: "Help and Support",
        //   onTap: () {
        //     // TODO: Navigate to Help
        //   },
        // ),
        const SizedBox(height: 10),
        ProfileOptionTile(
          icon: Icons.description_outlined,
          title: "Terms and Conditions",
          onTap: () async {
            final Uri url = Uri.parse(AppUrls.termsAndConditions);
            if (!await launchUrl(url)) {
              if (context.mounted) {
                showAppSnackbar(
                  context,
                  message: "Could not launch URL",
                  icon: Icons.error,
                );
              }
            }
          },
        ),
        const SizedBox(height: 10),
        ProfileOptionTile(
          icon: Icons.privacy_tip_outlined,
          title: "Privacy Policy",
          onTap: () async {
            final Uri url = Uri.parse(AppUrls.privacyPolicy);
            if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
              if (context.mounted) {
                showAppSnackbar(
                  context,
                  message: "Could not launch URL",
                  icon: Icons.error,
                );
              }
            }
          },
        ),
        const SizedBox(height: 10),
        ProfileOptionTile(
          icon: Icons.security_outlined,
          title: "Safety & Support",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SafetySupportScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        ProfileOptionTile(
          icon: Icons.logout,
          title: "Log Out",
          onTap: () => _showLogoutDialog(context),
        ),
        const SizedBox(height: 10),
        ProfileOptionTile(
          icon: Icons.delete_outline,
          title: "Delete Account",
          textColor: AppColor.primaryPink,
          iconColor: AppColor.primaryPink,
          onTap: () => _showDeleteAccountDialog(context),
        ),
      ],
    );
  }

  Future<void> _handleAccountStateChanges(
    BuildContext context,
    EmployeeAccountState state,
  ) async {
    if (state is LogoutLoading || state is DeleteAccountLoading) {
      showLoadingDialog(context);
    } else if (state is LogoutSuccess) {
      Navigator.pop(context);

      try {
        if (context.mounted) {
          context.read<EmployeeCubit>().reset();
          context.read<EmployeeCallCubit>().reset();
        }
      } catch (e) {}

      if (context.mounted) {
        showAppSnackbar(
          context,
          message: 'Logged out successfully',
          icon: Icons.check_circle,
          backgroundColor: Colors.green,
        );
        _navigateToLogin(context);
      }
    } else if (state is DeleteAccountSuccess) {
      Navigator.pop(context);

      await context.read<EmployeeSessionCubit>().cleanup();

      if (context.mounted) {
        showAppSnackbar(
          context,
          message: 'Account deleted successfully',
          icon: Icons.check_circle,
          backgroundColor: Colors.green,
        );
        _navigateToLogin(context);
      }
    } else if (state is LogoutFailure) {
      Navigator.pop(context);
      showAppSnackbar(context, message: state.error, icon: Icons.error);
    } else if (state is DeleteAccountFailure) {
      Navigator.pop(context);
      showAppSnackbar(context, message: state.error, icon: Icons.error);
    }
  }

  void _navigateToLogin(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (context.mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).clearSnackBars();

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.mobileNumber, (route) => false);
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showLogoutConfirmationDialog(context);

    if (confirmed && context.mounted) {
      context.read<EmployeeAccountCubit>().logout();
    }
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final confirmed = await showDeleteAccountConfirmationDialog(context);

    if (confirmed && context.mounted) {
      context.read<EmployeeAccountCubit>().deleteAccount();
    }
  }
}
