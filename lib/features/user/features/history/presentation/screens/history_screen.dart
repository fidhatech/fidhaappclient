import 'dart:developer';
import 'package:dating_app/core/widgets/gradient_scaffold/gradient_scaffold.dart';
import 'package:dating_app/features/user/features/history/cubit/history_cubit.dart';
import 'package:dating_app/features/user/features/history/presentation/widgets/history_screen_widgets/history_header.dart';
import 'package:dating_app/features/user/features/history/presentation/widgets/history_screen_widgets/history_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreenTab extends StatelessWidget {
  const HistoryScreenTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          left: 10.0,
          right: 10.0,
          bottom: 5.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HistoryHeader(),
            Expanded(
              child: BlocBuilder<HistoryCubit, HistoryState>(
                builder: (context, state) {
                  log('History UI State: ${state.runtimeType}');

                  if (state is HistoryInitial) {
                    log('History UI: Initial state, triggering fetch');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      context.read<HistoryCubit>().fetch();
                    });
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is HistoryLoading) {
                    log(' History UI: Loading state');
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is HistoryEmpty) {
                    log(' History UI: Empty state');
                    return const Center(child: Text('No history found'));
                  }

                  if (state is HistoryError) {
                    log(' History UI: Error state - ${state.message}');
                    return Center(child: Text(state.message));
                  }

                  if (state is HistoryLoaded) {
                    log(
                      ' History UI: Loaded state - Rendering ${state.historyList.length} items',
                    );
                    return HistoryList(users: state.historyList);
                  }

                  log(' History UI: Unknown state');
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
