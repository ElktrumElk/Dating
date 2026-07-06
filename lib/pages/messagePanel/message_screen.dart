import 'package:flutter/material.dart';
import 'package:untitled/global/chats/add_message.dart';
import 'package:untitled/global/chats/auto_sort_contact.dart';
import 'package:untitled/global/chats/user_chats.dart';
import 'package:untitled/main.dart';
import 'package:untitled/pages/messagePanel/chat_lists.dart';
import 'package:untitled/pages/messagePanel/userReplyPanelModifier/user_reply.dart';

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
    return ListenableBuilder(
      listenable: Listenable.merge([
        selectedContactIndex,
        replyTriggerNotifier,
        _messageController,
      ]),
      builder: (context, _) {
        final contactIndex = selectedContactIndex.value;
        final safeIndex = contactIndex < UserChats.contacts.length
            ? contactIndex
            : 0;
        final contact = UserChats.contacts[safeIndex];
        final reply = userReplyPanel[contact.name];

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton.filled(
              onPressed: () {
                chatSubPageNotifier.value = 0;
                isBottomNavigation.value = true;
              },
              icon: const Icon(Icons.arrow_back_rounded),
              color: Colors.black,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[200],
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
                    color: Color(0xFFE10087),
                    borderRadius: BorderRadius.circular(100),
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
                color: Colors.black,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  elevation: 10,
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                onPressed: () {},
                icon: const Icon(Icons.video_call),
                color: Colors.black,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  elevation: 10,
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(child: ChatLists(messages: contact.messages)),

              Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: 12,
                  right: 12,
                  top: 8,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                ),
                child: Column(
                  children: [
                    // ===============================================================
                    if (reply?.isReply == true)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(color: Colors.pink, width: 3),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 20,
                            top: 5,
                            bottom: 5,
                          ),
                          child: SizedBox(
                            width: double.maxFinite,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reply?.username ?? '',
                                      style: TextStyle(
                                        fontWeight: FontWeight(600),
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      reply?.messageReplyTo ?? '',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                // ========Column===========================
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      reply?.isReply = false;
                                    });
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Text Field ====================================
                    //
                    //================================================
                    Row(
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
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          crossFadeState: _messageController.text.isEmpty
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: IconButton.filled(
                            onPressed: () {},
                            icon: const Icon(Icons.mic),

                            color: Colors.white,
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.pinkAccent,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                          secondChild: const SizedBox.shrink(),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: () {
                            if (_messageController.text.trim().isNotEmpty) {
                              setState(() {
                                AddMessage().addMessage(
                                  Message(
                                    text: _messageController.text,
                                    isSender: true,
                                    replyToUsername: reply?.username,
                                    replyToText: reply?.messageReplyTo,
                                  ),
                                );
                              });
                              reply?.clear();
                              replyTriggerNotifier.value++;
                              selectedContactIndex.value = 0;
                              _messageController.clear();
                              AutoSortContact.instance.sort(contact.name);
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
                    // =====================ROW===============================
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
