import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dating_app/core/network/socket/socket_service.dart';
import 'package:dating_app/di/injection.dart';
import 'package:dating_app/features/employee/home/cubit/employee_cubit.dart';
import 'package:dating_app/features/employee/main/cubit/navigator_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class EmployeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EmployeeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
      builder: (context, state) {
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 20,
          title: Builder(
            builder: (context) {
              if (state is EmployeeLoading) {
                return Shimmer.fromColors(
                  baseColor: Colors.white24,
                  highlightColor: Colors.white54,
                  child: Container(
                    width: 100,
                    height: 30, // Adjusted height for text
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              } else if (state is EmployeeSuccess) {
                const colorizeColors = [
                  Colors.white,
                  Color(0xffd946ef),
                  Color(0xfff472b6),
                  Color(0xffc084fc),
                ];

                final colorizeTextStyle = const TextStyle(
                  fontSize: 35,
                  fontFamily: 'GreatVibes',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Color(0x88f472b6),
                      offset: Offset(0, 2),
                    ),
                  ],
                );

                return AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Fidha',
                      textStyle: colorizeTextStyle,
                      colors: colorizeColors,
                      speed: const Duration(milliseconds: 500),
                      textAlign: TextAlign.start,
                    ),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true,
                );
              }
              return const Text(
                'Fidha',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'GreatVibes',
                ),
              );
            },
          ),
          actions: [
            Builder(
              builder: (context) {
                if (state is EmployeeLoading) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.white24,
                          highlightColor: Colors.white54,
                          child: Container(
                            width: 80,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Shimmer.fromColors(
                          baseColor: Colors.white24,
                          highlightColor: Colors.white54,
                          child: const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state is EmployeeSuccess) {
                  final employee = state.employee;
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to profile page (index 2)
                        final navCubit = context.read<EmployeeNavigatorCubit>();
                        navCubit.changePage(2);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            employee.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                backgroundImage: (employee.avatar.isNotEmpty)
                                    ? NetworkImage(employee.avatar.first)
                                    : null,
                                child: (employee.avatar.isEmpty)
                                    ? const Icon(
                                        Icons.person,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: StreamBuilder<bool>(
                                  stream: sl<SocketService>()
                                      .connectionStatusStream,
                                  initialData: sl<SocketService>().isConnected,
                                  builder: (context, snapshot) {
                                    final isConnected = snapshot.data ?? false;
                                    return Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: isConnected
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                (isConnected
                                                        ? Colors.greenAccent
                                                        : Colors.redAccent)
                                                    .withValues(alpha: 0.5),
                                            blurRadius: 4,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
