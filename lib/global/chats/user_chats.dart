enum MessageStatus { sent, delivered, seen }

class Message {
  final String text;
  final String sentAt;
  final bool isSender;
  final MessageStatus status;
  final String? replyToUsername;
  final String? replyToText;

  Message({
    required this.text,
    this.isSender = false,
    this.status = MessageStatus.sent,
    String? sentAt,
    this.replyToUsername,
    this.replyToText,
  }) : sentAt = sentAt ??
            '${DateTime.now().hour}:${DateTime.now().minute} ${DateTime.now().hour > 12 ? "PM" : "AM"}';
}

class Contact {
  final String name;
  final String imageUrl;
  final List<Message> messages;
  final int unreadCount;

  String get lastMessage => messages.last.text;
  String get lastMessageTime => messages.last.sentAt;

  Contact({
    required this.name,
    this.imageUrl = '',
    required this.messages,
    this.unreadCount = 0,
  });
}

class UserChats {
  static List<Contact> contacts = [
    Contact(

      name: 'Alice Gborie',
      unreadCount: 1,
      messages: [
        Message(text: 'Hey, how are you?', isSender: true, status: MessageStatus.seen),
        Message(text: 'I am good, thanks! How about you?'),
        Message(text: 'What are you up to?', isSender: true, status: MessageStatus.delivered),
        Message(text: 'Just working on some projects'),
        Message(text: 'Sounds great! Let me know if you need help', isSender: true, status: MessageStatus.sent),
      ],
    ),
    Contact(
      name: 'William Evans',
      messages: [
        Message(text: 'Hey Williams'),
        Message(text: 'Hello! Long time no see'),
        Message(text: 'Yeah, it has been a while', isSender: true, status: MessageStatus.delivered),
      ],
    ),
    Contact(
      name: 'Sarah Johnson',
      unreadCount: 3,
      messages: [
        Message(text: 'Are you free this weekend?'),
        Message(text: 'Yes, I am! What do you have in mind?', isSender: true, status: MessageStatus.seen),
        Message(text: 'There is a new restaurant downtown'),
        Message(text: 'Sounds like a plan!', isSender: true, status: MessageStatus.sent),
        Message(text: 'Great, I will book for 7pm'),
      ],
    ),
  ];


}
