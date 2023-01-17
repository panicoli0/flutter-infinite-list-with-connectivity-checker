import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_infinite_list/bloc/network_bloc.dart';

class NetworkHelper {
  static void observeNetwork() {
    //this package checks connectivity status not network status so
    //this class should contain more advanced checks

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      crossCheck();
    });
  }

  static Future<void> crossCheck() async {
    //You can ignore these lines and future.delay, logic is the point
    await Future.delayed(const Duration(seconds: 1));
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult  == ConnectivityResult.none) {
      NetworkBloc().add(NetworkNotify());
    } else {
      NetworkBloc().add(NetworkNotify(isConnected: true));
    }
  }
}
