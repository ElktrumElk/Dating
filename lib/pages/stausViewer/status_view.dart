import 'package:flutter/material.dart';
import 'package:untitled/global/userStory/story.dart';
import 'package:untitled/global/userStory/user_story.dart';
import 'package:untitled/global/variables/global_variables.dart';

class StatusView extends StatefulWidget {
  const StatusView({super.key});

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  final List<double> progressBars = [0.2, 0, 0, 0];
  bool isDrag = false;

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
  }

  @override
  void dispose() {
    super.dispose();
    UserStoryVariable.currentIndexStatus = 0;
    UserStoryVariable.innerIndex = 0;
    UserStoryVariable.timer?.cancel();
    HandleStory().removeListener(_onStoryUpdate);
  }

  @override
  Widget build(BuildContext context) {
    final double screenW = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onVerticalDragEnd: (e) {
          if (mounted) {
            Navigator.pop(context);
          }
          isDrag = false;
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff1c0115), Color(0xff0c0309), Color(0xff0c0109)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 20,
                margin: const EdgeInsets.only(top: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: UserStory
                      .userStories[UserStoryVariable.currentIndexStatus]
                      .stories
                      .asMap()
                      .entries
                      .map((entry) {
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
                              color: Colors.pinkAccent,
                              value: barValue,
                              minHeight: 5,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      })
                      .toList(),
                ),
              ),

              // =======================================
              // Status View box
              //=======================================
              GestureDetector(
                onTap: () {
                  if (!UserStoryVariable.isPause) {
                    HandleStory().pause();
                    UserStoryVariable.isPause = true;
                  } else {
                    HandleStory().start();
                    UserStoryVariable.isPause = false;
                  }
                },

                onDoubleTapDown: (details) {
                  final tapX = details.localPosition.dx;
                  if (tapX < screenW / 2) {
                    HandleStory().previous();
                  } else {
                    HandleStory().next();
                  }
                },

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      height: 600,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InteractiveViewer(
                        maxScale: 4.0,
                        minScale: 1.0,
                        clipBehavior: Clip.none,
                        child: SizedBox(
                          width: double.infinity,
                          height: 600,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                UserStory
                                    .userStories[UserStoryVariable.currentIndexStatus]
                                    .stories[UserStoryVariable.innerIndex],
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    UserStoryVariable.isStatusLoaded = true;
                                    HandleStory().start();
                                  }
                                  return child ?? const SizedBox();
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.broken_image_outlined,
                                    color: Colors.pink,
                                  );
                                },
                              ),
                              if (!UserStoryVariable.isStatusLoaded)
                                Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      color: Colors.pinkAccent,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),

                    Row(
                      children: [
                        IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          color: Colors.white,
                          style: FilledButton.styleFrom(
                            backgroundColor: Color(0x992D2D35),
                          ),
                        ),
                        IconButton.filled(
                          onPressed: () {},
                          icon: const Icon(Icons.repeat_rounded),
                          color: Colors.white,
                          style: FilledButton.styleFrom(
                            backgroundColor: Color(0x992D2D35),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          UserStory
                              .userStories[UserStoryVariable.currentIndexStatus]
                              .username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
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
                      style: FilledButton.styleFrom(
                        backgroundColor: Color(0x992D2D35),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
