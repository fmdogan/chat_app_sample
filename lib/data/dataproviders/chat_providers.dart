import 'package:bloc_chat/data/models/chat.dart';
import 'package:bloc_chat/data/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDataProvider {
  CollectionReference chatsCollection = FirebaseFirestore.instance.collection('chats');
  List _users = [];

  Future<Chat> getOrCreateChat({required List usersIDs}) async {
    Chat _currentChat = Chat(id: '', users: [], messages: []);
    String chatDocId = '';
    CollectionReference messagesCollection;
    // ignore: unused_local_variable
    Map<String, dynamic> chatData;
    List<Message> _messages = [];

    // sort users so it will be stored in firestore in order
    _users = usersIDs;
    if (_users[0].compareTo(_users[1]) > 0) {
      _users = [usersIDs[1], usersIDs[0]];
    }

    await chatsCollection.where('users', isEqualTo: _users).get().then((docsSnapshot) async => {
          /// if chat doesn't exist yet
          if (docsSnapshot.docs.isEmpty)
            {
              await chatsCollection.add({
                'users': _users,
              }).then((_newDoc) {
                print("Chat created");
                _currentChat = Chat(id: _newDoc.id, users: _users, messages: []);
              }).catchError((error) {
                print("Failed to create chat: $error");
              }),
            }
          else
            {
              chatData = docsSnapshot.docs.first.data() as Map<String, dynamic>,

              /// here it receives messages belonging to this chat
              chatDocId = docsSnapshot.docs.first.id,
              messagesCollection = chatsCollection.doc(chatDocId).collection('messages'),

              await messagesCollection.orderBy('time').get().then((messagesSnapshot) {
                print('message collection isEmpty: ${messagesSnapshot.docs.isEmpty}');

                if (messagesSnapshot.docs.isNotEmpty) {
                  print('in if messageSnapshot check');
                  messagesSnapshot.docs.forEach((_messageDoc) {
                    _messages.add(Message.fromDocument(_messageDoc));
                  });
                }
                _currentChat = Chat.fromDocument(docsSnapshot.docs.first, _messages);
              }),
            }
        });
    return _currentChat;
  }

  Future insertMessage(Message message, Chat chat) async {
    String chatDocId = chat.id;
    print('in insertMessage: chat users: ${chat.users[0]} : ${chat.users[1]}');

    // chatDoc id is given manuelly. must be dynamic chat.id //////////////////////////////////
    await chatsCollection.doc(chatDocId).get().then((value) => {
          print('chat doc id: ' + value.id),
          chatDocId = value.id,
          chatsCollection
              .doc(chatDocId)
              .collection('messages')
              .add(
                message.toDocument(),
              )
              .then((_newDoc) {
            print('message inserted');
          })
              // ignore: invalid_return_type_for_catch_error
              .catchError((error) {
            print("Failed to insert doc: $error");
          }),
        });
  }
}
