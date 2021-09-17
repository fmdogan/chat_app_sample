import 'dart:async';

import 'package:bloc_chat/data/dataproviders/chat_providers.dart';
import 'package:bloc_chat/data/models/chat.dart';
import 'package:bloc_chat/data/models/message.dart';

class ChatRepo {
  ChatDataProvider _chatProvider = ChatDataProvider();

  Future<Chat> getChatData({required List usersIDs}) async {
    Chat _chat = await _chatProvider.getOrCreateChat(usersIDs: usersIDs);
    return _chat;
  }

  Future<void> sendMessage({required Message message, required Chat chat}) async {
    await _chatProvider.insertMessage(message, chat);
  }

  //Stream<QuerySnapshot<Map<String, dynamic>>> streamChatsCollection =
  //    FirebaseFirestore.instance.collection('chats').snapshots();

  // doesn't use chatProvider directly..
  Stream<List<Message>> getMessages(Chat chat) {
    print('chatrepo/streamGetMessages: chat.id: ${chat.id}');
    return _chatProvider.chatsCollection
        .doc(chat.id)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Message.fromDocument(doc)).toList();
    });
  }
}
