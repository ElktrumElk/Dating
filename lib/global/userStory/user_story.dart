import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled/global/userStory/story.dart';
import 'package:untitled/global/variables/global_variables.dart';

class Story {
  final String username;
  final List stories;

  const Story({required this.username, required this.stories});
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
  final Stopwatch _stopwatch = Stopwatch();

  void start() {
    UserStoryVariable.timer?.cancel();
    _stopwatch.start();

    UserStoryVariable.timer = Timer.periodic(Duration(milliseconds: 100), (
      timer,
    ) {
      if (!UserStoryVariable.isStatusLoaded) {
        return;
      }
      // Check if progressbar has complete
      if (UserStoryVariable.progressValue >= 1.0) {
          // check if all the status has been looped through
          if (UserStoryVariable.currentIndexStatus >= _stories.length) {
            UserStoryVariable.timer?.cancel();
            timer.cancel();
            _stopwatch.stop();
            _stopwatch.reset();
            clearStatus.call();
            UserStoryVariable.isStatusLoaded = false;

            return;
          }
          // Checked if the specific story has been looped through
          if (UserStoryVariable.innerIndex <
              _stories[UserStoryVariable.currentIndexStatus].stories.length -
                  1) {
            UserStoryVariable.innerIndex += 1;
            UserStoryVariable.progressValue = 0.0;
            UserStoryVariable.isStatusLoaded = false;
          } else {
            UserStoryVariable.innerIndex = 0;
            UserStoryVariable.progressValue = 0.0;
            UserStoryVariable.currentIndexStatus += 1;
            UserStoryVariable.isStatusLoaded = false;
          }
          // Double check if all status has been completed to prevent crash
          if (UserStoryVariable.currentIndexStatus >= _stories.length) {
            timer.cancel();
            _stopwatch.stop();
            _stopwatch.reset();
            clearStatus.call();
            UserStoryVariable.isStatusLoaded = false;
            return;
          }
          _stopwatch.reset();
          _stopwatch.start();
          notifyListeners();
        } else {
          UserStoryVariable.progressValue += 0.02;
          notifyListeners();
        }
      });
  }

  void pause() {
    _stopwatch.stop();
    UserStoryVariable.timer?.cancel();
  }

  void next() {
    UserStoryVariable.timer?.cancel();
    UserStoryVariable.progressValue = 0.0;

    if (UserStoryVariable.innerIndex <
        _stories[UserStoryVariable.currentIndexStatus].stories.length - 1) {
      UserStoryVariable.innerIndex += 1;
      notifyListeners();
      start();
    } else {
      if (UserStoryVariable.currentIndexStatus >= _stories.length - 1) {
        clearStatus.call();
        return;
      }
      UserStoryVariable.innerIndex = 0;
      UserStoryVariable.currentIndexStatus += 1;
      notifyListeners();
      start();
    }
  }

  void previous() {
    UserStoryVariable.timer?.cancel();
    UserStoryVariable.progressValue = 0.0;

    if (UserStoryVariable.innerIndex > 0) {
      UserStoryVariable.innerIndex -= 1;
      notifyListeners();
      start();
    } else {
      if (UserStoryVariable.currentIndexStatus > 0) {
        UserStoryVariable.currentIndexStatus -= 1;
        UserStoryVariable.innerIndex =
            _stories[UserStoryVariable.currentIndexStatus].stories.length - 1;
        notifyListeners();
        start();
      } else {
        UserStoryVariable.innerIndex = 0;
        notifyListeners();
        start();
      }
    }
  }
}
