part of 'network_bloc.dart';

abstract class NetworkState {
  const NetworkState();
}

class NetworkInitial extends NetworkState {}

// ignore: must_be_immutable
class NetworkChangedState extends NetworkState {
  late bool isConnected;

  NetworkChangedState({required this.isConnected});
}
