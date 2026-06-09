import '../../splash/user_auth/presentation/cubit/carousel_cubit.dart';
import '../../splash/user_auth/presentation/widgets/join_community_screen_widgets/join_community_screen_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/di.dart';
import '../../../core/services/firebase_notification_service.dart';

class JoinCommunityScreen extends StatefulWidget {
  const JoinCommunityScreen({super.key});

  @override
  State<JoinCommunityScreen> createState() => _JoinCommunityScreenState();
}

class _JoinCommunityScreenState extends State<JoinCommunityScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      getIt.get<FirebaseNotificationService>().checkAndRequestPermission(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CarouselCubit(totalPages: 3),
      child: const JoinCommunityScreenBody(),
    );
  }
}
