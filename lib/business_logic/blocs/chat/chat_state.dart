part of 'chat_bloc.dart';

abstract class ChatState {}

class ChatLoadingState extends ChatState {}

// ignore: must_be_immutable
class ChatUpdatedState extends ChatState {
  late Chat chat;
  ChatUpdatedState({
    required this.chat,
  });
}
