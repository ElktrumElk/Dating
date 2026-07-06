

class UserReply {
  String username;
  String messageReplyTo;
  bool isReply;

   UserReply({
    required this.username,
    required this.messageReplyTo,
    this.isReply = false
});

  void clear() {
    username = '';
    messageReplyTo = '';
    isReply = false;
  }
  void init(String username, String message) {
    this.username = username;
    messageReplyTo = message;
    isReply = true;
  }
}

Map<String, UserReply> userReplyPanel= {};
String currentUserPanel = '';