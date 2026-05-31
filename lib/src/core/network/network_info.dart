import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract interface for checking network connectivity
abstract class NetworkInfo {
  /// Check if the device is connected to the internet
  Future<bool> get isConnected;

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged;
}

/// Implementation of NetworkInfo using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (results) => !results.contains(ConnectivityResult.none),
    );
  }
}

