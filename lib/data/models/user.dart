import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  late String id;
  late String name;
  String fcmId = "";
  String pushyId = "";
  List<dynamic> chats = [];

  User({
    required this.id,
    required this.name,
    fcmId,
    pushyId,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'name': name,
      'fcm_id': fcmId,
      'pushy_id': pushyId,
    };
  }

  static User fromDocument(DocumentSnapshot _doc) {
    final _docData = _doc.data() as Map<String, dynamic>;
    // ignore: unnecessary_null_comparison
    if (_docData == null) throw Exception();
    return User(
      id: _docData['id'],
      name: _docData['name'],
      fcmId: _docData['fcm_id'],
      pushyId: _docData['pushy_id'],
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'fcm_id': fcmId,
      'pushy_id': pushyId,
    };
  }

  static User fromJson(Map<String, Object> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      fcmId: json['fcm_id'] as String,
      pushyId: json['pushy_id'] as String,
    );
  }
}

User loggedUser = User(id: '', name: '');
List<User> usersList = [];
