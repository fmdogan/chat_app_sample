part of 'network_bloc.dart';

abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object> get props => [];
}

class NetworkListenEvent extends NetworkEvent {}

class NetworkInitialEvent extends NetworkEvent {}

// ignore: must_be_immutable
class NetworkChangedEvent extends NetworkEvent {
  late bool isConnected;
  NetworkChangedEvent({
    required this.isConnected,
  });
}
