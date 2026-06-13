part of '../pages/user_details_screen.dart';

class _ActionButtonsBar extends StatelessWidget {
  final EmployeeModel employee;

  const _ActionButtonsBar({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30,
      left: 20,
      right: 20,
      child: Row(
        children: [
          Expanded(
            child: _BuildActionButton(
              icon: Icons.call,
              rate: employee.audioCallRate ?? 0,
              color: AppColor.enabledButton,
              isVideo: false,
              onTap: () {
                context.read<ClientCallCubit>().initiateCall(
                  employee.empId,
                  employee.name,
                  employee.avatar ?? '',
                  CallType.audio,
                );
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _BuildActionButton(
              icon: Icons.videocam,
              rate: employee.videoCallRate ?? 0,
              color: AppColor.disabledButton,
              isVideo: true,
              onTap: () {
                context.read<ClientCallCubit>().initiateCall(
                  employee.empId,
                  employee.name,
                  employee.avatar ?? '',
                  CallType.video,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildActionButton extends StatelessWidget {
  final IconData icon;
  final int rate;
  final Color color;
  final bool isVideo;
  final VoidCallback onTap;

  const _BuildActionButton({
    required this.icon,
    required this.rate,
    required this.color,
    required this.isVideo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.icons.coinStack,
                height: 20,
                width: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '$rate/min',
                style: const TextStyle(
                  color: AppColor.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: AppColor.primaryText, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
