import 'package:dating_app/di/injection.dart';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';

import 'package:dating_app/features/call/call_permission_service.dart';
import 'package:dating_app/features/call/call_waiting/screens/call_waiting_screen.dart';
import 'package:dating_app/features/call/screens/call_ui_kit.dart';
import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:dating_app/features/user/features/call/cubit/client_call_cubit.dart';
import 'package:dating_app/features/user/features/call/model/call_type.dart';
import 'package:dating_app/features/user/features/premium/bloc/premium_bloc.dart';
import 'package:dating_app/features/user/features/premium/widgets/premium_screen_widgets/premium_cards_grid.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PremiumScreenTab extends StatelessWidget {
  const PremiumScreenTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<PremiumBloc>()..add(FetchPremiumEvent()),
      child: BlocBuilder<PremiumBloc, PremiumState>(
        builder: (context, state) {
          if (state is PremiumInitial || state is PremiumLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PremiumError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PremiumBloc>().add(FetchPremiumEvent());
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state is PremiumLoaded) {
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

                  CallPermissionService.requestCallPermissions(context).then((
                    granted,
                  ) {
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
                            userId: currentUserId,
                            userName: currentUserName,
                            callType: state.joinData.callType == 'audio'
                                ? CallType.audio
                                : CallType.video,
                            onEndCall: () {
                              context.read<ClientCallCubit>().endCall(
                                state.callId,
                              );
                            },
                          ),
                        ),
                      );
                    }
                  });
                } else if (state is ClientCallEnded ||
                    state is ClientCallError) {
                  if (Navigator.canPop(context)) Navigator.pop(context);

                  String message = "Call Ended";
                  if (state is ClientCallError) {
                    message = "Call failed. Please try again.";
                  } else if (state is ClientCallEnded) {
                    message = "Call Ended";
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor: state is ClientCallError
                          ? Colors.red
                          : null,
                    ),
                  );
                }
              },
              child: GradientScaffold(
                body: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20,
                    left: 10.0,
                    right: 10.0,
                    bottom: 2.0,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            context.read<PremiumBloc>().add(
                              FetchPremiumEvent(),
                            );
                          },
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                PremiumCardsGrid(
                                  response: state.premiumEmployeesList,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
