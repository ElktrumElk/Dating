
import 'package:flutter/material.dart';
import 'package:untitled/global/network/posts.dart';

class ImageNetwork extends StatelessWidget {
  final List<AddPosts> posts;
  final int index;

  const ImageNetwork({super.key, required this.posts, this.index = 0});

  @override
  Widget build(BuildContext context) {
    return // 1. Background Image (Bottom Layer)
    Image.network(
      posts[index].imageUrl,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
      loadingBuilder:
          (
            BuildContext context,
            Widget child,
            ImageChunkEvent? loadingProgress,
          ) {
            if (loadingProgress == null) {
              return child;
            }

            return Center(
              child: CircularProgressIndicator(
                color: Colors.pink,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },

      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
        );
      },
    );
  }
}
