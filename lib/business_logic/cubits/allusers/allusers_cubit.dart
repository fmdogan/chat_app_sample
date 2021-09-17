import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/models/user.dart';
import 'package:bloc_chat/data/repositories/user_repo.dart';
import 'package:equatable/equatable.dart';

part 'allusers_state.dart';

class AllUsersCubit extends Cubit<AllUsersState> {
  AllUsersCubit() : super(AllUsersLoading());
  UserRepo _usersRepo = UserRepo();

  void getAllUsers() async {
    List<User> _users = await _usersRepo.getAllUsers();
    emit(AllUsersReady(users: _users));
  }
}
