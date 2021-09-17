import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloc_chat/data/models/user.dart';
export 'package:bloc_chat/data/models/user.dart';

class UserDataProvider {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(User _user) async {
    await usersCollection.doc(_user.id).set(_user.toDocument()).then((value) {
      print("User Added");
    }).catchError((error) {
      print("Failed to add user: $error");
    });
  }

  Future<User> getUser(String uid) async => await usersCollection.doc(uid).get().then((_userDoc) {
        if (_userDoc.exists) {
          return User.fromDocument(_userDoc);
        } else {
          return User(id: '', name: '');
        }
      });

  Future<List<User>> getAllUsers() async {
    // usersList stores all users data in app
    List<User> _usersList = [];
    await usersCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((_user) {
        if (_user['id'] != loggedUser.id) {
          _usersList.add(User.fromDocument(_user));
        }
      });
    });
    print('usersList length: ${_usersList.length}');
    return _usersList;
  }

  Future<void> setPushNotificationIDs(User _user) async {
    if (_user.fcmId != '') {
      await usersCollection
          .doc(_user.id)
          .update({'fcm_id': _user.fcmId}).catchError((error) => print("Failed to update user: $error"));
    }
    if (_user.pushyId != '') {
      await usersCollection
          .doc(_user.id)
          .update({'pushy_id': _user.pushyId}).catchError((error) => print("Failed to update user: $error"));
    }
  }
}
