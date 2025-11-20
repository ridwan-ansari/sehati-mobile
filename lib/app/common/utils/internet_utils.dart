// ignore_for_file: unrelated_type_equality_checks

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class InternetUtils {
  static final Connectivity _connectivity = Connectivity();

  static Future<bool> checkConnection() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  static Stream<bool> get connectionStream {
    return _connectivity.onConnectivityChanged.map(
      (result) => result != ConnectivityResult.none,
    );
  }
}
