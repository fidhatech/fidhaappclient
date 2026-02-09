import 'package:dating_app/features/splash/user_auth/presentation/cubit/carousel_cubit.dart';
import 'package:dating_app/features/splash/user_auth/presentation/widgets/join_community_screen_widgets/join_community_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JoinCommunityScreen extends StatelessWidget {
  const JoinCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CarouselCubit(totalPages: 3),
      child: const JoinCommunityScreenBody(),
    );
  }
}
