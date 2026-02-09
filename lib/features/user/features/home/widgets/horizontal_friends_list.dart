import 'dart:developer';

import 'package:dating_app/core/widgets/contact_item/contact_item_grid_tile.dart';
import 'package:dating_app/features/user/features/call/cubit/client_call_cubit.dart';
import 'package:dating_app/features/user/features/call/model/call_type.dart';
import 'package:dating_app/features/user/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HorizontalFriendsList extends StatelessWidget {
  final List<EmployeeModel> friends;

  const HorizontalFriendsList({super.key, required this.friends});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardHeight = screenWidth * 0.42;

    return SizedBox(
      height: cardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: friends.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final friend = friends[index];

          return InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/user_details_screen',
                arguments: friend,
              );
            },
            child: ContactGridCard(
              name: friend.name,
              age: friend.age.toString(),
              imageUrl: friend.avatar!,
              cardWidth: 0.40,
              onVideo: () {
                log("triggered");
                context.read<ClientCallCubit>().initiateCall(
                  friend.empId,
                  friend.name,
                  friend.avatar!,
                  CallType.video,
                );
              },
              onCall: () {
                log("triggered");
                context.read<ClientCallCubit>().initiateCall(
                  friend.empId,
                  friend.name,
                  friend.avatar!,
                  CallType.audio,
                );
              },
              isAudioEnabled: friend.isAudioEnabled,
              isVideoEnabled: friend.isVideoEnabled,
            ),
          );
        },
      ),
    );
  }
}
