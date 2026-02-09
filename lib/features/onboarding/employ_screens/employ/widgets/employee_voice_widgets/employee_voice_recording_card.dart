import 'package:dating_app/config/theme/app_color.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_voice_cubit/employee_voice_cubit.dart';
import 'package:dating_app/features/onboarding/employ_screens/employ/cubit/employee_voice_cubit/employee_voice_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeVoiceRecordingCard extends StatelessWidget {
  final String textToRead;
  const EmployeeVoiceRecordingCard({super.key, required this.textToRead});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 360),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // const SizedBox(height: ),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                textToRead,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          BlocBuilder<EmployeeVoiceCubit, EmployeeVoiceState>(
            builder: (context, state) {
              bool isRecording = state is EmployeeVoiceRecording;
              bool isRecorded = state is EmployeeVoiceRecorded;

              return Column(
                children: [
                  Text(
                    isRecording
                        ? "Recording..."
                        : isRecorded
                        ? "Tap to Re-record"
                        : "Tap to Speak",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      if (isRecording) {
                        context.read<EmployeeVoiceCubit>().stopRecording();
                      } else {
                        context.read<EmployeeVoiceCubit>().startRecording();
                      }
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: isRecording
                            ? [
                                BoxShadow(
                                  color: AppColor.primaryPink,
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        isRecording ? Icons.mic : Icons.mic_off,
                        color: Colors.black,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
