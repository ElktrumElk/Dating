import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled/global/variables/global_variables.dart';

class Story {
  final String username;
  final List stories;

  const Story({required this.username, required this.stories});
}

class UserStory {
  static List<Story> userStories = [
    Story(
      username: 'alice gborie',
      stories: [Colors.yellow, Colors.red, Colors.white],
    ),
    Story(
      username: 'william evans',
      stories: [Colors.purple, Colors.lightGreen, Colors.orange, Colors.green],
    ),
    Story(
      username: 'sarah johnson',
      stories: [Colors.yellow, Colors.red, Colors.brown],
    ),
  ];
}

class HandleStory with ChangeNotifier {
  late Function clearStatus;

  static final HandleStory _instance = HandleStory._internal();

  HandleStory._internal();

  factory HandleStory() {
    return _instance;
  }

  void init({required Function clearStatus}) {
    this.clearStatus = clearStatus;
  }

  static final List<Story> _stories = UserStory.userStories;

  // curr = 3
  // inner = 0
  void start() {
    UserStoryVariable.timer = Timer.periodic(Duration(milliseconds: 100), (
      timer,
    ) {
      if (UserStoryVariable.progressValue >= 1.0) {
        if (UserStoryVariable.currentIndexStatus >= _stories.length) {
          UserStoryVariable.timer.cancel();
          timer.cancel();
          clearStatus.call();

          return;
        }

        if (UserStoryVariable.innerIndex <
            _stories[UserStoryVariable.currentIndexStatus].stories.length - 1) {
          UserStoryVariable.innerIndex += 1;
          UserStoryVariable.progressValue = 0.0;
        } else {
          UserStoryVariable.innerIndex = 0;
          UserStoryVariable.progressValue = 0.0;
          UserStoryVariable.currentIndexStatus += 1;
        }
        if (UserStoryVariable.currentIndexStatus >= _stories.length) {
          timer.cancel();

          clearStatus.call();

          return;
        }
        notifyListeners();
      } else {
        UserStoryVariable.progressValue += 0.02;
        notifyListeners();
      }
    });
  }

  void pause() {

  }
}
