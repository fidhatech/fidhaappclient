import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dating_app/core/utils/network_checker.dart';
import 'package:equatable/equatable.dart';

enum NetworkStatus { online, offline }

class NetworkStatusState extends Equatable {
  final NetworkStatus status;

  const NetworkStatusState({required this.status});

  factory NetworkStatusState.initial() =>
      const NetworkStatusState(status: NetworkStatus.online);

  @override
  List<Object> get props => [status];
}

class NetworkStatusCubit extends Cubit<NetworkStatusState> {
  final NetworkChecker _networkChecker;
  StreamSubscription<bool>? _subscription;

  static const String _tag = '[NETWORK]';

  NetworkStatusCubit(this._networkChecker)
    : super(NetworkStatusState.initial()) {
    _monitorConnectivity();
  }

  void _monitorConnectivity() {
    log('$_tag Initializing NetworkStatusCubit');

    // Initial check
    _checkInitialStatus();

    // Listen to stream
    _subscription = _networkChecker.onConnectivityChanged.listen((isConnected) {
      _updateStatus(isConnected);
    });
  }

  Future<void> _checkInitialStatus() async {
    final isConnected = await _networkChecker.isConnected;
    _updateStatus(isConnected);
  }

  void _updateStatus(bool isConnected) {
    final newStatus = isConnected
        ? NetworkStatus.online
        : NetworkStatus.offline;
    if (state.status != newStatus) {
      log('$_tag Status changed: $newStatus');
      emit(NetworkStatusState(status: newStatus));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
