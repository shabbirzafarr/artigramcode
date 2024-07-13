import 'package:artplace/Core/Utils/ErrorText.dart';
import 'package:artplace/Core/Utils/Loader.dart';
import 'package:artplace/Core/Utils/Snackbar.dart';
import 'package:artplace/Features/Post/Controller/PostController.dart';
import 'package:artplace/Features/Post/Widget/CommentTile.dart';
import 'package:artplace/Models/Post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Authentication/Controller/AuthController.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    if(commentController.text.isNotEmpty){
      ref.read(postControllerProvider.notifier)
    .addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
    }
    else{
      showSnackBar(context, "Comment is Empty");
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: ref.watch(getPostByIdProvider(widget.postId)).when(
              data: (data) {
                return Column(
                  children: [
                    
                        TextField(
                          onSubmitted: (val) => addComment(data),
                          controller: commentController,
                          decoration: const InputDecoration(
                            hintText: 'Post Your comment',
                            filled: true,
                            border: InputBorder.none,
                          ),
                        ),
                        
                    
                            Container(
                              height: 500,
                              child: ListView.builder(
                                itemCount: data.comments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print(data.comments[index]);
                                  return ref.watch(getPostCommentsProvider(data.comments[index])).when(data: (data){
                                    return CommentCard(comment: data,ans:(data.username==user.username));
                                  },
                                 error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () =>  Loader(),
                                  );
                                },
                              ),)
                            
                  ]
                          
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () =>  Loader(),
            ),
      ),
    );
  }
}