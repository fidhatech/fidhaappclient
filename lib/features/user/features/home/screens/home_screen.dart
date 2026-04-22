import 'package:dating_app/core/services/firebase_notification_service.dart';
import 'package:dating_app/features/call/call_permission_service.dart';
import 'package:dating_app/features/call/call_waiting/screens/call_waiting_screen.dart';
import 'package:dating_app/features/call/screens/call_ui_kit.dart';
import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:dating_app/features/user/features/call/cubit/client_call_cubit.dart';
import 'package:dating_app/features/user/features/call/model/call_type.dart';
import 'package:dating_app/features/user/features/home/bloc/home_bloc.dart';
import 'package:dating_app/features/user/features/home/bloc/home_event.dart';
import 'package:dating_app/features/user/features/home/bloc/home_state.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/user/features/home/screens/filter_screen.dart';
import 'package:dating_app/features/user/features/home/utils/home_helper.dart';
import 'package:dating_app/features/user/features/home/widgets/horizontal_friends_list.dart';
import 'package:dating_app/features/user/features/home/widgets/section_header.dart';
import 'package:dating_app/features/user/features/home/widgets/vertical_friends_list.dart';
import 'package:dating_app/core/widgets/profile_dialogs/profile_dialogs.dart';
import 'package:dating_app/features/wallet/cubit/wallet_cubit.dart';
import 'package:dating_app/features/wallet/screen/wallet_screen.dart';
import 'package:dating_app/di/injection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreenTab extends StatefulWidget {
  const HomeScreenTab({super.key});

  @override
  State<HomeScreenTab> createState() => _HomeScreenTabState();
}

class _HomeScreenTabState extends State<HomeScreenTab> {
  @override
  void initState() {
    super.initState();
    FirebaseNotificationService.registerTokenWithBackend();
  }

  @override
  Widget build(BuildContext context) {
    return _HomeScreenContent();
  }
}

class _HomeScreenContent extends StatelessWidget {
  const _HomeScreenContent();

  void _refreshUserBalanceAfterCall(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    userCubit.fetchUser();

    // Coin deduction/credit may arrive slightly after call-ended event.
    // Trigger a second refresh to avoid stale app-bar balance.
    Future.delayed(const Duration(seconds: 2), () {
      if (!context.mounted) return;
      userCubit.fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClientCallCubit, ClientCallState>(
      listener: (context, state) {
        if (state is ClientCallWaiting) {
          final callCubit = context.read<ClientCallCubit>();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallWaitingScreen(
                calleeName: state.callName,
                calleeAvatarUrl: state.avatarUrl,

                onEndCall: () => callCubit.endCall(state.callId ?? ''),
              ),
            ),
          );
        } else if (state is ClientCallJoined) {
          if (Navigator.canPop(context)) Navigator.pop(context);

          CallPermissionService.requestCallPermissions(context).then((granted) {
            if (!context.mounted) return;
            if (granted) {
              final userState = context.read<UserCubit>().state;
              String currentUserId = '';
              String currentUserName = '';

              if (userState is UserLoaded) {
                currentUserId = userState.userModel.userId;
                currentUserName = userState.userModel.name;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CallUiKit(
                    appId: state.joinData.appId,
                    callId: state.joinData.roomId,
                    token: state.joinData.token,
                    maxDurationSeconds: state.joinData.maxDurationSeconds,

                    userId: currentUserId,
                    userName: currentUserName,
                    callType: state.joinData.callType == 'audio'
                        ? CallType.audio
                        : CallType.video,
                    onEndCall: () {
                      context.read<ClientCallCubit>().endCall(state.callId);
                    },
                  ),
                ),
              );
            }
          });
        } else if (state is ClientCallInsufficientCoins) {
          if (Navigator.canPop(context)) Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => sl<WalletCubit>()..loadWalletData(),
                child: const WalletScreen(),
              ),
            ),
          );
        } else if (state is ClientCallEnded || state is ClientCallError) {
          if (Navigator.canPop(context)) Navigator.pop(context);

          _refreshUserBalanceAfterCall(context);
          context.read<HomeBloc>().add(const Filter());
        }
      },
      child: GradientScaffold(
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is HomeLoaded) {
              final seperated = HomeHelper.separate(
                state.responseModel.employees,
              );
              return Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SectionHeader(
                      title: 'Your Friends',
                      onFilterTap: () {
                        final homeBloc = context.read<HomeBloc>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: homeBloc,
                              child: const FilterScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            context.read<HomeBloc>().add(const Filter());
                            context.read<UserCubit>().fetchUser();
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Column(
                                children: [
                                  if (seperated.premium.isNotEmpty) ...[
                                    HorizontalFriendsList(
                                      friends: seperated.premium,
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                  if (seperated.normal.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: VerticalFriendsList(
                                        friends: seperated.normal,
                                      ),
                                    ),

                                  if (seperated.normal.isEmpty &&
                                      seperated.premium.isEmpty)
                                    Container(
                                      height: constraints.maxHeight,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.groups_outlined,
                                            size: 80,
                                            color: Colors.white.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "No friends found",
                                            style: TextStyle(
                                              color: Colors.white.withValues(
                                                alpha: 0.8,
                                              ),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                  if (seperated.normal.isNotEmpty ||
                                      seperated.premium.isNotEmpty)
                                    SizedBox(
                                      height:
                                          MediaQuery.of(
                                            context,
                                          ).padding.bottom +
                                          110,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
