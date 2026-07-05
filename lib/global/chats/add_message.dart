import 'package:untitled/global/chats/user_chats.dart';

/*
* # Helps to add new message to the message list when the send button is pressed
* */
class AddMessage {
  // The current contact user sending message to
  static String currentChatUser = '';

  void addMessage(Message message) {
    UserChats.contacts
        .where((x) => x.name == currentChatUser)
        .toList()
        .forEach((x) => x.messages.add(message));
  }
  set currentChat (String name) => currentChatUser = name;
}
