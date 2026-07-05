import 'package:flutter/cupertino.dart';
import 'package:untitled/global/chats/user_chats.dart';

class AutoSortContact with ChangeNotifier {
  List<Contact> _contacts = [];
  List<Contact> _sortedContact = [];

  void sort(String currentUser) {
    _contacts = UserChats.contacts.where((x) => x.name != currentUser).toList();
    _sortedContact = UserChats.contacts.where((x) => x.name == currentUser).toList();
    UserChats.contacts = [..._sortedContact, ..._contacts];
    notifyListeners();
  }
}
