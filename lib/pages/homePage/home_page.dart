import 'package:flutter/material.dart';
import 'package:untitled/global/network/posts.dart';
import 'package:untitled/pages/homePage/image/image_network.dart';
import 'package:untitled/pages/homePage/userDetails/user_info_overlay.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<AddPosts> posts = Posts.userPosts;

  // Dummy list of tags for demonstration
  final List<String> profileTags = [
    'Fashion',
    'Modeling',
    'Travel',
    'Art',
    'Music',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: posts.length,
        physics: const PageScrollPhysics(),
        itemBuilder: (context, index) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                // The huge display image
                ImageNetwork(posts: posts, index: index),

                UserInfoOverlay(
                  imageUrl: posts[index].imageUrl,
                  username: posts[index].username,
                  tags: posts[index].tag,
                ),


                Positioned(
                  right: 20,
                  top: MediaQuery.of(context).size.height / 2 - 25,
                  child: GestureDetector(
                    onTap: () {
                      print("Heart icon tapped for post $index");
                    },
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ),

                // 4. More Options Button Overlay
                Positioned(
                  right: 20,
                  bottom: 120,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      );
  }
}
