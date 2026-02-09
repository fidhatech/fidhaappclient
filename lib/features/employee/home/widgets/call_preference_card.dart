// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class CallPreferenceCard extends StatelessWidget {
//   const CallPreferenceCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<EmpHomeCubit, EmpHomeState>(
//       builder: (context, state) {
//         return Row(
//           children: [
//             Expanded(
//               child: _toggleButton(
//                 icon: state.isAudioEnabled ? Icons.mic : Icons.mic_off,
//                 label: 'Audio',
//                 isActive: state.isAudioEnabled,
//                 onTap: () => context.read<EmpHomeCubit>().toggleAudio(
//                   !state.isAudioEnabled,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _toggleButton(
//                 icon: state.isVideoEnabled
//                     ? Icons.videocam
//                     : Icons.videocam_off,
//                 label: 'Video',
//                 isActive: state.isVideoEnabled,
//                 onTap: () => context.read<EmpHomeCubit>().toggleVideo(
//                   !state.isVideoEnabled,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _toggleButton({
//     required IconData icon,
//     required String label,
//     required bool isActive,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//         decoration: BoxDecoration(
//           color: isActive
//               ? Colors.purpleAccent.withValues(alpha: 0.2)
//               : Colors.white.withValues(alpha: 0.05),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: isActive
//                 ? Colors.purpleAccent.withValues(alpha: 0.5)
//                 : Colors.white.withValues(alpha: 0.1),
//           ),
//         ),
//         child: Column(
//           children: [
//             Icon(
//               icon,
//               color: isActive ? Colors.white : Colors.white54,
//               size: 28,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               label,
//               style: TextStyle(
//                 color: isActive ? Colors.white : Colors.white54,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
