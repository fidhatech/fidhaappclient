import 'package:auto_route/auto_route.dart';
import '../../model/premium_response_model.dart';
import '../premium_contact_card.dart';
import '../../../call/cubit/client_call_cubit.dart';
import '../../../call/model/call_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/routes/app_router.dart';

class PremiumCardsGrid extends StatelessWidget {
  final PremiumEmployeesResponse response;

  const PremiumCardsGrid({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemCount: response.hasMore
          ? response.employees.length + 1
          : response.employees.length,
      itemBuilder: (context, index) {
        if (index >= response.employees.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final card = response.employees[index];
        final displayName = card.name.trim().isEmpty ? 'Unknown User' : card.name;
        return PremiumContactCard(
          name: displayName,
          age: card.age.toString(),
          imageUrl:
              (card.profileImages != null && card.profileImages!.isNotEmpty)
              ? card.profileImages![0]
              : card.avatar ?? '',
          isOnline: card.status == 'online',
          isBusy: card.status == 'busy',
          isAudioEnabled: card.isAudioEnabled,
          isVideoEnabled: card.isVideoEnabled,
          audioCallRate: card.audioCallRate,
          videoCallRate: card.videoCallRate,
          onTap: () {
            context.router.push(UserDetailsRoute(args: card));
          },
          onAudioCall: () {
            context.read<ClientCallCubit>().initiateCall(
              card.empId,
              displayName,
              card.avatar ?? '',
              CallType.audio,
            );
          },
          onVideoCall: () {
            context.read<ClientCallCubit>().initiateCall(
              card.empId,
              displayName,
              card.avatar ?? '',
              CallType.video,
            );
          },
        );
      },
    );
  }
}
