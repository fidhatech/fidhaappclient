import 'package:dating_app/core/widgets/contact_item/contact_item_list_tile.dart';
import 'package:dating_app/features/user/features/call/cubit/client_call_cubit.dart';
import 'package:dating_app/features/user/features/call/model/call_type.dart';
import 'package:dating_app/features/user/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerticalFriendsList extends StatelessWidget {
  final List<EmployeeModel> friends;
  final double? itemHeight;

  const VerticalFriendsList({
    super.key,
    required this.friends,
    this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        final friend = friends[index];
        final item = ContactItem(
          name: friend.name,
          age: friend.age.toString(),
          imageUrl: friend.avatar!,
          isAudioAvailable: friend.isAudioEnabled,
          isVideoAvailable: friend.isVideoEnabled,
          audioCallRate: friend.audioCallRate,
          videoCallRate: friend.videoCallRate,
          onCall: () {
            context.read<ClientCallCubit>().initiateCall(
              friend.empId,
              friend.name,
              friend.avatar!,
              CallType.audio,
            );
          },
          onVideoCall: () {
            context.read<ClientCallCubit>().initiateCall(
              friend.empId,
              friend.name,
              friend.avatar!,
              CallType.video,
            );
          },
        );

        if (itemHeight != null) {
          return SizedBox(height: itemHeight, child: item);
        }
        return item;
      },
    );
  }
}
