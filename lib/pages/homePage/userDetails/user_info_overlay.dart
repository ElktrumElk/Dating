import 'package:flutter/material.dart';

class UserInfoOverlay extends StatelessWidget {
  final String imageUrl;
  final String username;
  final List<String> tags;

  const UserInfoOverlay({
    super.key,
    required this.imageUrl,
    required this.username,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 120, // Pushes it comfortably above system nav bars
      left: 15,
      // Gives it a safe right-side boundary so it doesn't overlap the actions column
      width: MediaQuery.of(context).size.width - 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular Profile Photo Thumbnail
          Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),

          // Username Text Display
          Text(
            username,
            style: const TextStyle(
              fontSize: 26,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(blurRadius: 8.0, color: Colors.black54),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Wrapping Responsive Tag Tiles
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: tags.map((tagName) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(50),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white30, width: 1),
                ),
                child: Text(
                  tagName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
