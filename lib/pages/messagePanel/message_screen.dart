import 'package:flutter/material.dart';
import 'package:untitled/global/chatController/chat_controller.dart';
import 'package:untitled/global/chats/user_chats.dart';
import 'package:untitled/main.dart';
import 'package:untitled/pages/messagePanel/chat_lists.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listens directly to selectedContactIndex updates so that tapping a
    // different user immediately switches the headers and messages shown.
    return ValueListenableBuilder<int>(
      valueListenable: selectedContactIndex,
      builder: (context, contactIndex, _) {
        // Fallback protection in case index out of bounds
        final safeIndex = contactIndex < UserChats.contacts.length ? contactIndex : 0;
        final contact = UserChats.contacts[safeIndex];

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton.filled(
              onPressed: () {
                // Route smoothly back to the ChartScreen list view
                chatSubPageNotifier.value = 0;
                // Instantly re-show your main global bottom navigation bar
                isBottomNavigation.value = true;
              },
              icon: const Icon(Icons.arrow_back_rounded),
              color: Colors.white,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                elevation: 10,
              ),
            ),
            title: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: ListTile(
                leading: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(100),
                    // If your contact object contains a profile image URL, apply it here:
                    // image: DecorationImage(image: AssetImage(contact.profilePath)),
                  ),
                ),
                contentPadding: const EdgeInsets.all(1),
                title: Text(
                  contact.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  'Online',
                  style: TextStyle(color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            actions: [
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.call),
                color: Colors.white,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  elevation: 10,
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.video_call),
                color: Colors.white,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  elevation: 10,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: ChatLists(messages: contact.messages),
          bottomSheet: Container(
            color: Colors.white,
            padding: EdgeInsets.only(
              left: 12,
              right: 12,
              top: 8,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      // TODO: Add sending operational method here
                      // chatController.sendMessage(safeIndex, _messageController.text);
                      print('Sending message to ${contact.name}: ${_messageController.text}');
                      _messageController.clear();
                    }
                  },
                  icon: const Icon(Icons.send_rounded),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
