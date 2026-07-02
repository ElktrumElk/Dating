import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChatTabManager extends TickerProvider {
  late final TabController chatTabController;


  ChatTabManager(int length) {
    // Initializes the controller using 'this' as the vsync provider
    chatTabController = TabController(length: length, vsync: this);
  }

  // Mandatory override: Tells the controller how to create an animation clock frame
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);

  // Always include a cleanup method to prevent memory leaks when the manager is discarded
  void dispose() {
    chatTabController.dispose();
  }
}
