import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkInitial());
  StreamSubscription? _subscriptionToConnectivity;

  @override
  Stream<NetworkState> mapEventToState(NetworkEvent event) async* {
    if (event is NetworkInitialEvent) {
      Connectivity().checkConnectivity();
      var connectivityResult = await (Connectivity().checkConnectivity());

      yield NetworkChangedState(
        isConnected:
            (connectivityResult == ConnectivityResult.mobile) || (connectivityResult == ConnectivityResult.wifi),
      );
    } else if (event is NetworkListenEvent) {
      _subscriptionToConnectivity?.cancel();
      _subscriptionToConnectivity = Connectivity().onConnectivityChanged.listen((status) {
        print('networkbloc/listen/ networkstatus: $status');
        add(
          NetworkChangedEvent(
            isConnected: ((status == ConnectivityResult.mobile) || (status == ConnectivityResult.wifi)),
          ),
        );
      });
    } else if (event is NetworkChangedEvent) {
      print('networkbloc/changedEvent/ event.isconnected: ${event.isConnected}');
      yield NetworkChangedState(isConnected: event.isConnected);
    }
  }

  @override
  Future<void> close() {
    _subscriptionToConnectivity?.cancel();
    return super.close();
  }
}
