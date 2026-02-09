import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkChecker {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkCheckerImpl implements NetworkChecker {
  final Connectivity connectivity;

  NetworkCheckerImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map((results) {
      return !results.contains(ConnectivityResult.none);
    });
  }
}
