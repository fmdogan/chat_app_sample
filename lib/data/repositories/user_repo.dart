import 'package:bloc_chat/data/dataproviders/user_providers.dart';
//import 'package:bloc_chat/data/models/user.dart';

class UserRepo {
  UserDataProvider _userDataProvider = UserDataProvider();

  Future<User> createUser({required User user}) {
    _userDataProvider.addUser(user);
    return _userDataProvider.getUser(user.id);
  }

  Future<User> getUser({required String uid}) async {
    User _user = await _userDataProvider.getUser(uid);
    return _user;
  }

  Future<List<User>> getAllUsers() async {
    List<User> _users = await _userDataProvider.getAllUsers();
    return _users;
  }

  void insertPushNotificationIDs({required User user}) {
    _userDataProvider.setPushNotificationIDs(user);
  }
}
