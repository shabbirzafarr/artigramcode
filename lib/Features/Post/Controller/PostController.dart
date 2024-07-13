import 'dart:io';

import 'package:artplace/Core/Constants/StorageRepositoryProvidor.dart';
import 'package:artplace/Features/Post/Repository/PostRepo.dart';
import 'package:artplace/Features/UserProfile.dart/Controller/UserProfileController.dart';
import 'package:artplace/Models/Comments.dart';
import 'package:artplace/Models/UserModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../Core/Utils/Snackbar.dart';
import '../../../Models/Post.dart';
import '../../Authentication/Controller/AuthController.dart';
final getPostByIdProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});
final postControllerProvider = StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
    postRepository: postRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});
final getPostCommentsProvider = StreamProvider.family((ref, String postId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComments(postId);
});


class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
   PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _postRepository = postRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);
  void shareImagePost({
    required BuildContext context,
    required String title,
    required String caption,
    required UserModel? user,
    required File? file,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
      path: 'posts/${user.username}',
      id: postId,
      file: file,
    );

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
        id: postId,
        username: user.username,
        title: title,
        caption: caption,
        imageUrl: r,
        createdAt: DateTime.now(),
        upvotes: [],
        downvotes: [],
        comments: []
      );

      final res = await _postRepository.addPost(post);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        _ref.read(userProvider.notifier).update((state) => r);
        showSnackBar(context, 'Posted successfully!');
        Routemaster.of(context).push("/");
      });
    });
  }
  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }
  void getallpost(BuildContext context)async{
    state=true;
    final res=_ref.read(userProvider)!.following;
    final res1=_ref.read(postProvidor)!;
    final ans= await _postRepository.fetchnotallpost(res,res1);
    state=false;
    ans.fold((l)=> showSnackBar(context, l.message), (r){
      _ref.read(postProvidor.notifier).update((state) => r);
    });
    
  }
  void upvote(Post post) async {
    final uid = _ref.read(userProvider)!.username;
    _postRepository.upvote(post, uid);
  }

  void downvote(Post post) async {
    final uid = _ref.read(userProvider)!.username;
    _postRepository.downvote(post, uid);
  }
  void deletePost(Post post, BuildContext context) async {
    final res = await _postRepository.deletePost(post);
    res.fold((l) => null, (r) {
      Navigator.pop(context);
      _ref.watch(userProvider.notifier).update((state) => r);
      
      showSnackBar(context, 'Post Deleted successfully!');
      
      

    });
  }
   Stream<Comment> fetchPostComments(String id) {
    return _postRepository.getCommentById(id);
  }
   void addComment({
    required BuildContext context,
    required String text,
    required Post post,
  }) async {
    final user = _ref.read(userProvider)!;
    String commentId = const Uuid().v1();
    Comment comment = Comment(
      id: commentId,
      text: text,
      createdAt: DateTime.now(),
      postId: post.id,
      username: user.name,
      
    );
    final res = await _postRepository.addComment(comment);
    res.fold((l) => showSnackBar(context, l.message), (r) {
     showSnackBar(context, r);
    });
  }
  void deleteComment(BuildContext context,Comment comment) async{
    final res = await _postRepository.deleteComment(comment);
    res.fold((l) => showSnackBar(context, l.message), (r) {
     showSnackBar(context, r);
    });
  }
}