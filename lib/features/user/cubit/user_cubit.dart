import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/core/network/cubit/network_status_cubit.dart';
import 'package:dating_app/features/user/features/home/repository/home_repo.dart';
import 'package:dating_app/features/user/models/user_model.dart';
import 'package:equatable/equatable.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final HomeRepository repository;
  final NetworkStatusCubit networkStatusCubit;
  StreamSubscription? _networkSubscription;
  static const String _tag = '[UserCubit]';

  UserCubit({required this.repository, required this.networkStatusCubit})
    : super(UserInitial()) {
    _monitorNetwork();
  }

  void _monitorNetwork() {
    _networkSubscription = networkStatusCubit.stream.listen((networkState) {
      if (networkState.status == NetworkStatus.online) {
        if (state is ErrorState || state is UserInitial) {
          log('$_tag Network restored. Retrying fetchUser...');
          fetchUser();
        }
      }
    });
  }

  void fetchUser() async {
    log("fetchcalled");

    if (networkStatusCubit.state.status == NetworkStatus.offline) {
      emit(ErrorState("No Internet Connection"));
      return;
    }

    if (isClosed) return;
    emit(UserLoading());
    try {
      final data = await repository.fetchHome();
      log('UserCubit: fetched data: ${data.name}');
      if (!isClosed) emit(UserLoaded(data));
    } catch (e) {
      log('UserCubit: error $e');
      if (!isClosed) emit(ErrorState(e.toString()));
    }
  }

  void reset() {
    if (!isClosed) {
      _networkSubscription?.cancel();
      emit(UserInitial());
    }
  }

  @override
  Future<void> close() {
    _networkSubscription?.cancel();
    return super.close();
  }
}
