import 'package:flutter/material.dart';
import 'package:untitled/global/network/posts.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Fetch your posts list from your single-instance Posts tracker
    final matchesPost = Posts.userPosts;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text(
            'Matches',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          floating: true,
        ),
        SliverFillRemaining(
          child: Container(
            color: Colors.white,
            child: GridView.builder(
              itemCount: matchesPost.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio:
                    0.75, // Keeps cards perfectly proportioned (tall rectangles)
              ),
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                // 3. Grab the active iterated item block instance
                final postItem = matchesPost[index];

                return Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Temporary fallback box color
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,

                      child: Image.network(
                        postItem.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withAlpha(150),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 30,
                      left: 12,
                      right: 12,
                      child: Text(
                        postItem.username,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Text(
                        '12km Away',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 15,
                        ),
                      ),
                    ),
  
                    Positioned(
                      bottom: 60,
                      right: 12,
                      child: IconButton.filled(
                        onPressed: () {},
                        icon: Icon(Icons.close),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.withAlpha(50),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: IconButton.filled(
                        onPressed: () {},
                        icon: Icon(Icons.favorite_border_outlined),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.withAlpha(50),
                        ),
                      ),
                    ),

                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
