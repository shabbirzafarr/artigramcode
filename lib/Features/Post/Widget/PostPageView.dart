import 'package:artplace/Core/Utils/ErrorText.dart';
import 'package:artplace/Core/Utils/Loader.dart';
import 'package:artplace/Features/Authentication/Controller/AuthController.dart';
import 'package:artplace/Features/Post/Controller/PostController.dart';
import 'package:artplace/Models/Post.dart';
import 'package:artplace/Models/UserModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Screen/CommentSection.dart';

class PostPage extends ConsumerStatefulWidget {
  final String uid;
  const PostPage(this.uid);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  void downvote(Post post) {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void upvote(Post post) {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void deletePost(Post post) {
    ref.read(postControllerProvider.notifier).deletePost(post, context);
  }

  void commentBox(String postId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsScreen(postId: postId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Page'),
      ),
      body: ref.watch(getPostByIdProvider(widget.uid)).when(
            data: (data) => SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildPostImage(data),
                    buildPostDetails(data),
                    buildActionButtons(data, user!),
                    
                  ],
                ),
              ),
            ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => Loader(),
          ),
    );
  }

  Widget buildPostImage(Post data) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(data.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildPostDetails(Post data) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Flexible(
            child: Text(
              data.username,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              data.caption,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildActionButtons(Post data, UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildIconButtonWithLabel(
            icon: Icons.thumb_up,
            label: '${data.upvotes.length} Upvotes',
            color: data.upvotes.contains(user.username) ? Colors.blue : null,
            onPressed: () => upvote(data),
          ),
          buildIconButtonWithLabel(
            icon: Icons.thumb_down,
            label: '${data.downvotes.length} Downvotes',
            color: data.downvotes.contains(user.username) ? Colors.red : null,
            onPressed: () => downvote(data),
          ),
          buildIconButtonWithLabel(
            icon: Icons.comment,
            label: '${data.comments.length} Comments',
            onPressed: () => commentBox(data.id),
          ),
          (data.username == user.username)?buildIconButtonWithLabel(
            icon: Icons.delete,
            label: 'Delete',
            onPressed: () => deletePost(data),
          ):SizedBox(width: 10,),
        ],
      ),
    );
  }

  Widget buildIconButtonWithLabel({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: color),
          onPressed: onPressed,
        ),
        Text(label),
      ],
    );
  }

 
}
