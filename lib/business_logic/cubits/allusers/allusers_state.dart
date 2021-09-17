part of 'allusers_cubit.dart';

abstract class AllUsersState extends Equatable {
  const AllUsersState();

  @override
  List<Object> get props => [];
}

class AllUsersLoading extends AllUsersState {}

// ignore: must_be_immutable
class AllUsersReady extends AllUsersState {
  List<User> users = [];
  AllUsersReady({
    required this.users,
  });
}
