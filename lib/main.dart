import 'package:flutter/material.dart';

import 'package:untitled/components/taskBar/task_bar_component.dart';

import 'package:untitled/pages/chartPage/chart_screen.dart';
import 'package:untitled/pages/homePage/home_page.dart';
import 'package:untitled/pages/likesPage/likes_page.dart';
import 'package:untitled/pages/matchPage/match_screen.dart';
import 'package:untitled/pages/messagePanel/message_screen.dart';

void main() {
  //debugPaintLayerBordersEnabled = true;
  runApp(const MyApp());
}

// State management notifiers
ValueNotifier<int> selectedContactIndex = ValueNotifier<int>(0);
// Dedicated notifier to handle inner routing between ChartScreen (0) and MessageScreen (1)
ValueNotifier<int> chatSubPageNotifier = ValueNotifier<int>(0);
ValueNotifier<bool> isBottomNavigation = ValueNotifier<bool>(true);
ValueNotifier<int> replyTriggerNotifier = ValueNotifier<int>(0);

final PageController pageController = PageController(initialPage: 0);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Listen to changes on the notifier to animate the PageView automatically
    chatSubPageNotifier.addListener(_handleSubPageRouting);
  }

  @override
  void dispose() {
    chatSubPageNotifier.removeListener(_handleSubPageRouting);
    pageController.dispose();
    super.dispose();
  }

  // Animates the sub-pages smoothly whenever chatSubPageNotifier updates
  void _handleSubPageRouting() {
    if (pageController.hasClients) {
      final targetPage = chatSubPageNotifier.value;
      if (pageController.page?.round() != targetPage) {
        pageController.animateToPage(
          targetPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return DefaultTabController(
          length: 2,
          child: Stack(
            children: [
              TabBarView(
                children: [
                  Material(color: Colors.black, child: HomePage()),
                  LikesPage(),
                ],
              ),
              TaskBarComponent(),
            ],
          ),
        );
      case 1:
        return const MatchScreen();
      case 2:
      // Completed PageView configuration matching your predefined screens
        return PageView(
          controller: pageController,
          onPageChanged: (int pageIndex) {
            chatSubPageNotifier.value = pageIndex;
            // Dynamically hide bottom bar if the user swipes manually into the MessageScreen
            isBottomNavigation.value = (pageIndex == 0);
          },
          children: const [
            ChartScreen(),   // Page index 0
            MessageScreen(), // Page index 1
          ],
        );
      case 3:
        return const Center(
          child: Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        );
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dating',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: null,
        extendBody: true,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body: _buildBody(),
        bottomNavigationBar: ListenableBuilder(
          listenable: isBottomNavigation,
          builder: (context, _) {
            // Evaluates visibility using the proper bottom bar state manager
            return isBottomNavigation.value
                ? NavigationBar(
              height: 50,
              selectedIndex: _currentIndex,
              elevation: 0,
              backgroundColor: _currentIndex != 0
                  ? Colors.white
                  : Colors.transparent,
              indicatorColor: Colors.pink.withAlpha(50),
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined, color: Colors.grey),
                  selectedIcon: Icon(Icons.explore, color: Colors.pink),
                  label: 'Discover',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border, color: Colors.grey),
                  selectedIcon: Icon(Icons.favorite, color: Colors.pink),
                  label: 'Matches',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline, color: Colors.grey),
                  selectedIcon: Icon(Icons.chat_bubble, color: Colors.pink),
                  label: 'Chats',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_2_outlined, color: Colors.grey),
                  selectedIcon: Icon(Icons.person, color: Colors.pink),
                  label: 'Profile',
                ),
              ],
            )
                : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
