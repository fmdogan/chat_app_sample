import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_chat/data/models/chat.dart';
import 'package:bloc_chat/data/models/message.dart';
import 'package:bloc_chat/data/models/user.dart';
import 'package:bloc_chat/data/repositories/chat_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatLoadingState());
  ChatRepo _chatRepo = ChatRepo();
  StreamSubscription<List<Message>>? _subscriptionToChatStream;

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is ChatSendMessageEvent) {
      yield* _mapSendMessageToState(event);
    } else if (event is ChatRefreshMessagesEvent) {
      yield* _mapRefreshMessagesToState(event);
    } else if (event is ChatRefreshedEvent) {
      yield* _mapChatRefreshedToState(event);
    } else if (event is ChatLoadNewEvent) {
      yield ChatLoadingState();
    }
  }

  Stream<ChatState> _mapSendMessageToState(ChatSendMessageEvent event) async* {
    // sets the message.time in UTC time zone
    Timestamp _time = Timestamp.fromDate(DateTime.now());
    await _chatRepo
        .sendMessage(
          chat: event.chat,
          message: Message(text: event.messageText, from: loggedUser.id, time: _time),
        )
        .whenComplete(() async {});
  }

  Stream<ChatState> _mapRefreshMessagesToState(ChatRefreshMessagesEvent event) async* {
    print('chatbloc/streamRefreshMessages: chat.id: ${event.chat.id}');
    _subscriptionToChatStream?.cancel();
    _subscriptionToChatStream = _chatRepo.getMessages(event.chat).listen((_messages) {
      event.chat.messages = _messages;
      print('event.chat.messages length in stream: ${event.chat.messages.length}');
      add(ChatRefreshedEvent(chat: event.chat));
    });
  }

  Stream<ChatState> _mapChatRefreshedToState(ChatRefreshedEvent event) async* {
    print('messages length after stream: ${event.chat.messages.length}');
    yield ChatUpdatedState(chat: event.chat);
  }
}
