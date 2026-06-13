import '../../../../di/injection.dart';
import '../../cubit/user_cubit.dart';
import '../call/cubit/client_call_cubit.dart';
import '../history/cubit/history_cubit.dart';
import '../home/bloc/home_bloc.dart';
import 'cubit/navigator_cubit.dart';
import 'screen/main_screen.dart';
import '../premium/bloc/premium_bloc.dart';
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
        //BlocProvider(create: (_) => sl<ClientCallCubit>()),
        BlocProvider(create: (_) => sl<HomeBloc>()),
        BlocProvider(create: (_) => sl<NavigatorCubit>()),
      ],
      child: const MainScreen(),
    );
  }
}
