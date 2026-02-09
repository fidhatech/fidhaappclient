import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/employee_face_reveal_cubit/employee_face_reveal_cubit.dart';
import '../../cubit/employee_face_reveal_cubit/employee_face_reveal_state.dart';
import 'employee_face_reveal_card.dart';

/// A grid widget displaying the 4 image slots for face reveal.
///
/// Listens to [EmployeeFaceRevealCubit] to update the content of each slot.
class EmployeeFaceRevealGrid extends StatelessWidget {
  const EmployeeFaceRevealGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeFaceRevealCubit, EmployeeFaceRevealState>(
      builder: (context, state) {
        final cubit = context.read<EmployeeFaceRevealCubit>();
        final mediaFiles = state is EmployeeFaceRevealUpdated
            ? state.mediaFiles
            : <String>[];

        return GridView.count(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: List.generate(4, (index) {
            final mediaFile = mediaFiles.length > index
                ? mediaFiles[index]
                : null;
            return EmployeeFaceRevealCard(
              imagePath: mediaFile,
              onTap: () {
                cubit.pickImage(index);
              },
            );
          }),
        );
      },
    );
  }
}
