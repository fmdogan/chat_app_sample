import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_chat/business_logic/blocs/chat/chat_bloc.dart';
import 'package:bloc_chat/data/models/chat.dart';
import 'package:bloc_chat/data/models/message.dart';
import 'package:bloc_chat/data/models/user.dart';
import 'package:bloc_chat/presentation/widgets/chatAppBar.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  final Chat currentChat;
  final User targetuser;
  const ChatPage({
    Key? key,
    required this.currentChat,
    required this.targetuser,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState(
        currentChat: currentChat,
        targetuser: targetuser,
      );
}

class _ChatPageState extends State<ChatPage> {
  late Chat currentChat;
  final User targetuser;

  _ChatPageState({
    required this.currentChat,
    required this.targetuser,
  });

  TextEditingController messageBoxCTRL = new TextEditingController();
  ScrollController listViewCTRL = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // APPBAR
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: ChatAppBar(
          targetUser: targetuser,
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),

      // BODY
      body: Stack(children: <Widget>[
        Container(
            color: Theme.of(context).backgroundColor,
            child: Column(children: [
              BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {},
                builder: (context, state) {
                  // ChatLoading
                  if (state is ChatLoadingState) {
                    print('chatpage/loadingstate: currentchat id initially: ${currentChat.id}');
                    BlocProvider.of<ChatBloc>(context).add(ChatRefreshMessagesEvent(chat: currentChat));
                    return Expanded(child: Center(child: CircularProgressIndicator()));
                  } else

                  // ChatUpdated
                  if (state is ChatUpdatedState) {
                    List<Message> _messages = state.chat.messages;
                    print(
                      'chatpage/updatedstate: chat users: data: id: ' +
                          '${state.chat.id} : users: ${state.chat.users[0]} : ${state.chat.users[1]}',
                    );

                    return Expanded(
                      child: ListView.builder(
                          controller: listViewCTRL,
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            Message _message = _messages[_messages.length - index - 1];
                            String _time = Message.timestampToString(_message);

                            return Container(
                              height: 30,
                              margin: EdgeInsets.all(8),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                reverse: _message.from == loggedUser.id ? true : false,
                                children: [
                                  Container(
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: _message.from == loggedUser.id ? Colors.blue : Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.6),
                                          spreadRadius: 1,
                                          blurRadius: 1,
                                          offset: Offset(2, 2),
                                        )
                                      ],
                                    ),
                                    child: Text(
                                      _message.text,
                                      style: TextStyle(
                                          color: _message.from == loggedUser.id ? Colors.white : Colors.black),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(_time, style: TextStyle(fontSize: 10)),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    );
                  }
                  return Container(
                    height: 50,
                  );
                },
              ),
              Container(
                  color: Theme.of(context).primaryColor,
                  child: Row(children: [
                    // TextField
                    Expanded(
                      child: Container(
                        height: 40,
                        margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: messageBoxCTRL,
                          onEditingComplete: sendMessage,
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: sendMessage,
                        icon: Icon(
                          Icons.send,
                          color: Colors.white,
                        ))
                  ]))
            ]))
      ]),
    );
  }

  void sendMessage() {
    if (messageBoxCTRL.text.isNotEmpty) {
      BlocProvider.of<ChatBloc>(context).add(
        ChatSendMessageEvent(chat: currentChat, messageText: messageBoxCTRL.text),
      );
      messageBoxCTRL.clear();
    }
  }
}
