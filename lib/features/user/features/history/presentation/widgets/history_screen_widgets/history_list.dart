import 'package:dating_app/features/user/models/employee_model.dart';
import 'package:dating_app/features/user/features/history/model/history_model.dart';
import 'package:dating_app/features/user/features/history/presentation/widgets/history_screen_widgets/history_contact_item.dart';
import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final List<History> users;

  const HistoryList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 100),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/user_details_screen',
              arguments: EmployeeModel(
                empId: user.empId,
                name: user.employeeName,
                age: 0,
                avatar: user.employeeAvatar.isNotEmpty
                    ? user.employeeAvatar.first
                    : null,
                isPrime: false,
                interests: [],
                isAudioEnabled: false,
                isVideoEnabled: false,
                audioCallRate: 0,
                videoCallRate: 0,
                profileImages: user.employeeAvatar,
              ),
            );
          },
          child: HistoryContactItem(
            name: user.employeeName,
            time: user.time,
            imageUrl: user.employeeAvatar.isNotEmpty
                ? user.employeeAvatar.first
                : '',
            duration: user.duration.toString(),
            callType: user.callType,
          ),
        );
      },
    );
  }
}
