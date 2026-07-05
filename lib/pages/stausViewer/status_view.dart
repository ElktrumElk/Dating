import 'package:flutter/material.dart';
import 'package:untitled/global/userStory/user_story.dart';
import 'package:untitled/global/variables/global_variables.dart';

class StatusView extends StatefulWidget {
  const StatusView({super.key});

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  final List<double> progressBars = [0.2, 0, 0, 0];

  void _onStoryUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    HandleStory().init(
      clearStatus: () {
        if (mounted) {
          Navigator.pop(context);
        }
      },
    );

    HandleStory().addListener(_onStoryUpdate);
    HandleStory().start();
  }

  @override
  void dispose() {
    super.dispose();
    UserStoryVariable.currentIndexStatus = 0;
    UserStoryVariable.innerIndex = 0;
    UserStoryVariable.timer.cancel();
    HandleStory().removeListener(_onStoryUpdate);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.pinkAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 20,
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: UserStory.userStories[UserStoryVariable.currentIndexStatus].stories.asMap().entries.map((entry) {
                  int index = entry.key;
                  double barValue;

                  if (index < UserStoryVariable.innerIndex) {
                    barValue = 1.0;
                  } else if (index == UserStoryVariable.innerIndex) {
                    barValue = UserStoryVariable.progressValue;
                  } else {
                    barValue = 0.0;
                  }
                  return Flexible(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: LinearProgressIndicator(
                        color: Colors.black,
                        value: barValue,
                        minHeight: 5,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            Container(
              height: 600,
              decoration: BoxDecoration(
                color: UserStory
                    .userStories[UserStoryVariable.currentIndexStatus]
                    .stories[UserStoryVariable.innerIndex],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Icon(Icons.emoji_emotions, color: Colors.yellow),
              ),
            ),
            SizedBox(
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: TextField(
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                      maxLines: 1,
                      decoration: InputDecoration(
                        fillColor: Colors.black,
                        filled: true,
                        hintText: 'Say something...',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton.filled(
                    onPressed: () {},
                    icon: Icon(Icons.send, size: 30),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
