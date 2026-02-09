import 'package:dating_app/di/injection.dart';
import 'package:dating_app/features/user/cubit/user_cubit.dart';
import 'package:dating_app/features/user/features/call/cubit/client_call_cubit.dart';
import 'package:dating_app/features/user/features/history/cubit/history_cubit.dart';
import 'package:dating_app/features/user/features/home/bloc/home_bloc.dart';
import 'package:dating_app/features/user/features/navigation/cubit/navigator_cubit.dart';
import 'package:dating_app/features/user/features/navigation/screen/main_screen.dart';
import 'package:dating_app/features/user/features/premium/bloc/premium_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserScope extends StatelessWidget {
  const UserScope({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<UserCubit>()..fetchUser()),
        BlocProvider(create: (_) => sl<HistoryCubit>()),
        BlocProvider(create: (_) => sl<PremiumBloc>()),
        BlocProvider(create: (_) => sl<ClientCallCubit>()),
        BlocProvider(create: (_) => sl<HomeBloc>()),
        BlocProvider(create: (_) => sl<NavigatorCubit>()),
      ],
      child: const MainScreen(),
    );
  }
}
