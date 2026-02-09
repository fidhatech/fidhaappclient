import 'package:dating_app/features/user/features/premium/model/premium_response_model.dart';
import 'package:dating_app/features/user/features/premium/widgets/premium_contact_card.dart';
import 'package:dating_app/core/routes/app_routes.dart';
import 'package:dating_app/features/user/features/call/cubit/client_call_cubit.dart';
import 'package:dating_app/features/user/features/call/model/call_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return PremiumContactCard(
          name: card.name,
          age: card.age.toString(),
          imageUrl:
              (card.profileImages != null && card.profileImages!.isNotEmpty)
              ? card.profileImages![0]
              : card.avatar ?? '',
          isOnline: card.status == 'online',
          isAudioEnabled: card.isAudioEnabled,
          isVideoEnabled: card.isVideoEnabled,
          audioCallRate: card.audioCallRate,
          videoCallRate: card.videoCallRate,
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.userDetailsScreen,
              arguments: card,
            );
          },
          onAudioCall: () {
            context.read<ClientCallCubit>().initiateCall(
              card.empId,
              card.name,
              card.avatar ?? '',
              CallType.audio,
            );
          },
          onVideoCall: () {
            context.read<ClientCallCubit>().initiateCall(
              card.empId,
              card.name,
              card.avatar ?? '',
              CallType.video,
            );
          },
        );
      },
    );
  }
}
