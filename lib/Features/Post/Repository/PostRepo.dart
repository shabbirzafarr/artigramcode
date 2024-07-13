
import 'package:artplace/Core/Constants/FirebaseProvide.dart';
import 'package:artplace/Core/Utils/Failure.dart';
import 'package:artplace/Core/typdef.dart';

import 'package:artplace/Models/Comments.dart';
import 'package:artplace/Models/UserModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../Core/Constants/FirebaseConstant.dart';


import '../../../Models/Post.dart';
final postRepositoryProvider = Provider((ref) {
  return PostRepository(
    firestore: ref.watch(FirebaseProvidor.firestoreProvider),
  );
});
class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore}) : _firestore = firestore;
  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _comments => _firestore.collection(FirebaseConstants.commentsCollection);
   FutureEither<UserModel> addPost(Post post) async {
    try {
      await _posts.doc(post.id).set(post.toMap());
      await _users.doc(post.username).update({
        'posts': FieldValue.arrayUnion([post.id])
      });
      final u=await _users.doc(post.username).snapshots().first;
      UserModel users=UserModel.fromDocumentSnapshot(u);
      
      return right(users);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: "Failed"));
    }
  }
  FutureEither<UserModel> deletePost(Post post) async {
    try {
      _posts.doc(post.id).delete();
      final user=await _users.doc(post.username).update({'posts': FieldValue.arrayRemove([post.id])});
      final u=await _users.doc(post.username).snapshots().first;
      UserModel users=UserModel.fromDocumentSnapshot(u);
      
      return right(users);
      
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: "Failed"));
    }
  }
  void upvote(Post post, String userId) async {
    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }

  void downvote(Post post, String userId) async {
    if (post.upvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([userId]),
      });
    }

    if (post.downvotes.contains(userId)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([userId]),
      });
    } else {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([userId]),
      });
    }
  }
   Stream<Post> getPostById(String postId) {
    return _posts.doc(postId).snapshots().map((event) => Post.fromMap(event.data() as Map<String, dynamic>));
  }
  Stream<Comment> getCommentById(String id) {
    return _comments.doc(id).snapshots().map((event) => Comment.fromMap(event.data() as Map<String, dynamic>));

  }
  
  
  FutureEither<String> addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());
      _posts.doc(comment.postId).update({
        'comments': FieldValue.arrayUnion([comment.id]),
      });
      return right("Success");
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }
  FutureEither<String> deleteComment(Comment comment) async{
    try{
      await _comments.doc(comment.id).delete();
      _posts.doc(comment.postId).update({
        'comments': FieldValue.arrayRemove([comment.id]),
      });
      return right("Success");
    }catch(e){
      return left(Failure(message: "Failed!"));
    }
  }
  
  FutureEither<List<Post>> fetchnotallpost(List<dynamic> follower,List<Post> p)async{
    try{
      Set<String> postIds = p.map((post) => post.id).toSet();
      List<Post> posts=[];
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts')
        .where('username', whereIn: follower)
        .get();
      posts = snapshot.docs.map((doc) {
        if (postIds.contains(doc.id)) {
          return null; // Skip duplicate post
        } else {
          postIds.add(doc.id);
          return Post.fromMap(doc.data() as Map<String, dynamic>);
        }
      }).where((post) => post != null).toList().cast<Post>();
      print(posts.length);
      return right(posts);
    }
    catch(e){
      return left(Failure(message: "Failure"));
    }

  }
}