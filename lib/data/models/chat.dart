import 'package:bloc_chat/data/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  late String id;
  late List users;
  late List<Message> messages = [];
  Chat({
    required this.id,
    required this.users,
    required this.messages,
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'users': users,
    };
  }

  static Chat fromDocument(DocumentSnapshot _doc, List<Message> _messages) {
    final _docData = _doc.data() as Map<String, dynamic>;
    // ignore: unnecessary_null_comparison
    if (_docData == null) throw Exception();
    return Chat(
      id: _doc.id,
      users: _docData['users'],
      messages: _messages,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'users': users,
    };
  }

  static Chat fromJson(Map<String, Object> json) {
    return Chat(
      id: json['id'] as String,
      users: json['users'] as List<String>,
      messages: [],
    );
  }
}
