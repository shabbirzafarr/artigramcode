
import 'package:artplace/Core/Constants/FirebaseProvide.dart';
import 'package:artplace/Core/Utils/Failure.dart';
import 'package:artplace/Core/typdef.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../Core/Constants/FirebaseConstant.dart';
import '../../../Models/UserModels.dart';
final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(FirebaseProvidor.firestoreProvider));
});

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({required FirebaseFirestore firestore}) : _firestore = firestore;
   CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);

  FutureEither<UserModel> editProfile(UserModel user,String username) async {
    try {
      if(user.username==username) {
        await _users.doc(user.username).update(user.toMap());
      return right(user);
      }
      
      else{
        var ans=await _users.doc(username).get();
      if(ans.exists){
        return left(Failure(message: "Username already exist"));
      }
      await _users.doc(user.username).update(user.toMap());
      return right(user);
      }
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message:"Failed! Try again after sometime"));
    }
  }
  Stream<List<UserModel>> searchUser(String query) {
    return _users
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: query.isEmpty
              ? null
              : query.substring(0, query.length - 1) +
                  String.fromCharCode(
                    query.codeUnitAt(query.length - 1) + 1,
                  ),
        )
        .snapshots()
        .map((event) {
      List<UserModel> users = [];
      for (var community in event.docs) {
        users.add(UserModel.fromMap(community.data() as Map<String, dynamic>));
      }
      return users;
    });
  }
  FutureEither<UserModel> Follow(String pid,String uid) async {
    try {
      CollectionReference user=FirebaseFirestore.instance.collection(FirebaseConstants.usersCollection);
      await user.doc(pid).update({
        'following': FieldValue.arrayUnion([uid]),
      });
      await user.doc(uid).update({
        'followers': FieldValue.arrayUnion([pid]),
      });
      final u=await user.doc(uid).snapshots().first;
      UserModel users=UserModel.fromDocumentSnapshot(u);
      return right(users);
    } catch (e) {
      return left(Failure(message: "Failed!"));
    }
  }
  FutureEither<UserModel> Following(String pid,String uid) async {
    try {
      CollectionReference user=FirebaseFirestore.instance.collection(FirebaseConstants.usersCollection);
      await user.doc(pid).update({
        'following': FieldValue.arrayRemove([uid]),
      });
      await user.doc(uid).update({
        'followers': FieldValue.arrayRemove([pid]),
      });
      final u=await user.doc(uid).snapshots().first;
      UserModel users=UserModel.fromDocumentSnapshot(u);
      return right(users);
    } catch (e) {
      return left(Failure(message: "Failed!"));
    }
  }
  
}