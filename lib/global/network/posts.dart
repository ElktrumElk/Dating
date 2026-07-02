class AddPosts {
  final int id;
  final String username;
  final List<String> tag;
  final String imageUrl;


  const AddPosts({
    required this.id,
    required this.username,
    required this.tag,
    required this.imageUrl,
  });
}

class Posts {
  static final Posts _instance = Posts._internal();

  factory Posts() {
    return _instance;
  }

  Posts._internal();

  // Your original properties and methods remain perfectly intact
  static List<AddPosts> userPosts = [
    AddPosts(
      id: 0,
      username: 'Alice Gborie',
      tag: ['Fashion', 'Modeling', 'Art'],
      imageUrl:
          'https://plus.unsplash.com/premium_photo-1673758905772-e9f3ef20b354?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZmVtYWxlJTIwZmFzaGlvbiUyMHBvdHJhaXR8ZW58MHx8MHx8fDA%3D',

    ),
    AddPosts(
      id: 0,
      username: 'Liaah',
      tag: ['Style', 'Modeling', 'Design', 'Beauty'],
      imageUrl:
      'https://images.unsplash.com/photo-1635631414456-6a9dc5051a3d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZmVtYWxlJTIwZmFzaGlvbiUyMHBvdHJhaXR8ZW58MHx8MHx8fDA%3D',

    ),
  ];

  List<AddPosts> get getLists => userPosts;

  set addPost(AddPosts post) => userPosts.add(post);
}
