import 'package:flutter/material.dart';
import 'package:untitled/global/chats/user_chats.dart';
import 'package:untitled/main.dart';
import 'package:untitled/pages/messagePanel/userReplyPanelModifier/user_reply.dart';

class ChatLists extends StatefulWidget {
  final List<Message> messages;

  const ChatLists({super.key, required this.messages});

  @override
  State<ChatLists> createState() => _ChatListsScreen();
}

class _ChatListsScreen extends State<ChatLists> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, double> _bubbleOffsets = {};
  bool isThreshold = false;


  void _showReplyMessageSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 10),
        content: Center(child: Text('This the reply message')),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void didUpdateWidget(ChatLists oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length != oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        final isSender = message.isSender;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: isSender
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onHorizontalDragUpdate: (details) {

                  setState(() {
                    if ((_bubbleOffsets[index] ?? 0 ) <= -1) {return;}

                    if ((_bubbleOffsets[index] ?? 0) >= 50) {
                      isThreshold = true;
                    }
                    _bubbleOffsets[index] =
                        (_bubbleOffsets[index] ?? 0) + details.delta.dx;
                  });

                },
                onHorizontalDragEnd: (details) {
                  setState(() {
                    _bubbleOffsets.remove(index);

                  });

                  if (isThreshold) {
                    final contactName =
                        UserChats.contacts[selectedContactIndex.value].name;
                    userReplyPanel[contactName] = UserReply(
                      username: isSender ? 'You' : contactName,
                      messageReplyTo: message.text,
                      isReply: true,
                    );
                    replyTriggerNotifier.value++;
                  }
                isThreshold = false;
                },
                child: Transform.translate(
                  offset: Offset(_bubbleOffsets[index] ?? 0, 0),
                  child: Align(
                    alignment: isSender
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: isSender
                            ? const Color(0xFFE10087)
                            : const Color(0xFFD8D5D5),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: isSender
                              ? const Radius.circular(12)
                              : const Radius.circular(4),
                          bottomRight: isSender
                              ? const Radius.circular(4)
                              : const Radius.circular(12),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message.replyToText != null)
                                Container(
                                  width: double.maxFinite,
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    top: 4,
                                    bottom: 4,
                                    right: 4,
                                  ),
                                  margin: const EdgeInsets.only(bottom: 6),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: isSender
                                            ? Colors.white70
                                            : Colors.pinkAccent,
                                        width: 3,
                                      ),
                                    ),
                                    color: isSender
                                        ? Colors.white.withValues(alpha: 0.15)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.replyToUsername ?? '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isSender
                                              ? Colors.white70
                                              : Colors.pinkAccent,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        message.replyToText ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isSender
                                              ? Colors.white60
                                              : Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              Text(
                                message.text,
                                style: TextStyle(
                                  color: isSender ? Colors.white : Colors.black87,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  message.sentAt,
                                  style: TextStyle(
                                    color: isSender
                                        ? Colors.grey[300]
                                        : Colors.black,
                                    fontSize: 11,
                                  ),
                                ),
                                if (isSender) ...[
                                  const SizedBox(width: 4),
                                  Icon(
                                    message.status == MessageStatus.sent
                                        ? Icons.check
                                        : Icons.done_all,
                                    size: 14,
                                    color: message.status == MessageStatus.seen
                                        ? Colors.blue
                                        : Colors.black54,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ==============Align============================
                ),
              ),
            ],
          ),
          // ====================Column================
        );
        // ==================Padding==============================
      },
    );
  }
}
