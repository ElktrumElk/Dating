import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled/global/chatController/chat_controller.dart';
import 'package:untitled/global/chats/user_chats.dart';
import 'package:untitled/main.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  @override
  void initState() {
    super.initState();
    // Restores bottom navigation visibility whenever entering the primary list
    isBottomNavigation.value = true;
  }

  @override
  Widget build(BuildContext context) {
    final contacts = UserChats.contacts;

    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Chats',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          floating: true,
          elevation: 0,
        ),
        SliverFillRemaining(
          hasScrollBody: true,
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: SearchBar(
                    hintText: 'Search',
                    leading: const Icon(Icons.search),
                    backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.pink.withAlpha(90)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Horizontal Stories/Status List
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 110),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 70,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade100,
                                  border: Border.all(color: Colors.pink, width: 2),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                height: 65,
                                width: 65,
                                child: const Icon(Icons.person, color: Colors.pink, size: 35),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                index == 0 ? 'My Story' : 'User $index',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),

                // Vertical Contacts Conversation Feed
                Expanded(
                  child: ListView.builder(
                    itemCount: contacts.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return Material(
                        color: Colors.white,
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            height: 55,
                            width: 55,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                          title: Text(
                            contact.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            contact.lastMessage,
                            style: const TextStyle(color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                contact.lastMessageTime,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 5),
                              if (contact.unreadCount > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.pink,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    '${contact.unreadCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          onTap: () {

                            selectedContactIndex.value = index;
                            isBottomNavigation.value = false;

                            chatSubPageNotifier.value = 1;
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
