import 'package:flutter/material.dart';

class TaskBarComponent extends StatelessWidget {
  const TaskBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Material(
        color: Colors.transparent,
        child: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.pink,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'For You'),
            Tab(text: 'Likes'),
          ],
        ),
      ),
    );
  }
}
