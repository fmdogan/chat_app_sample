part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class ChatSendMessageEvent extends ChatEvent {
  late Chat chat;
  late String messageText;
  ChatSendMessageEvent({
    required this.chat,
    required this.messageText,
  });
}

// ignore: must_be_immutable
class ChatRefreshMessagesEvent extends ChatEvent {
  late Chat chat;
  ChatRefreshMessagesEvent({
    required this.chat,
  });
}

// ignore: must_be_immutable
class ChatRefreshedEvent extends ChatEvent {
  late Chat chat;
  ChatRefreshedEvent({
    required this.chat,
  });
}

class ChatLoadNewEvent extends ChatEvent {}
