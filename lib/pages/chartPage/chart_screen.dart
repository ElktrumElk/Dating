import 'package:flutter/material.dart';

import 'package:untitled/global/chats/auto_sort_contact.dart';
import 'package:untitled/global/chats/user_chats.dart';
import 'package:untitled/global/userStory/user_story.dart';
import 'package:untitled/global/variables/global_variables.dart';
import 'package:untitled/main.dart';
import 'package:untitled/pages/stausViewer/status_view.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<Contact> _filterContacts = [];

  static final List<Story> _storyItems = UserStory.userStories;

  final AutoSortContact _sortContact = AutoSortContact();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isBottomNavigation.value = true;
    _filterContacts = List.from(UserChats.contacts);
    _sortContact.addListener(_onSortChanged);
    _searchController.addListener(_filterContactsMethod);
  }

  @override
  void dispose() {
    _sortContact.removeListener(_onSortChanged);
    _searchController.removeListener(_filterContactsMethod);
    _searchController.dispose();
    super.dispose();
  }

  void _onSortChanged() {
    setState(() {
      _filterContacts = List.from(UserChats.contacts);
    });
  }

  void _filterContactsMethod() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filterContacts = UserChats.contacts.where((contact) {
        return contact.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: SearchBar(
                    hintText: 'Search',
                    leading: const Icon(Icons.search),
                    controller: _searchController,
                    backgroundColor: const WidgetStatePropertyAll(Colors.white),
                    side: WidgetStatePropertyAll(
                      BorderSide(color: Colors.pink.withAlpha(90)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Horizontal Stories/Status List ==========================
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 110),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    itemCount: _storyItems.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final story = _storyItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 70,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  UserStoryVariable.currentIndexStatus = index;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StatusView(),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.pink.shade100,
                                    border: Border.all(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  height: 65,
                                  width: 65,
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.red,
                                    size: 35,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                story.username,
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
                    itemCount: _filterContacts.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final contact = _filterContacts[index];
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
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            contact.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
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

class _StoryItemData {
  final String name;
  final Color backgroundColor;

  _StoryItemData({required this.name, required this.backgroundColor});
}
