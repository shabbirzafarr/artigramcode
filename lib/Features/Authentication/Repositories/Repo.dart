import 'package:artplace/Core/Constants/FirebaseConstant.dart';
import 'package:artplace/Core/Constants/FirebaseProvide.dart';
import 'package:artplace/Core/Utils/Failure.dart';
import 'package:artplace/Core/typdef.dart';
import 'package:artplace/Models/UserModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
final AuthRepositoryProvider=Provider((ref) => AuthRepository(ref.read(FirebaseProvidor.authProvider),ref.read(FirebaseProvidor.firestoreProvider)));
class AuthRepository{
  FirebaseAuth _auth;
  FirebaseFirestore _firestore;
  AuthRepository(this._auth,this._firestore);
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  Stream<User?> get authStateChange => _auth.authStateChanges();
  late UserModel user;
  FutureEither<UserModel> createAccount(String email,String password,String name,String username) async {
    try {
      var ans=await _users.doc(username).get();
      if(ans.exists){
        return left(Failure(message: "Username already exist"));
      }
      
      UserCredential cred= await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user=UserModel(name: name, username: username, email: email, profilePic: "", followers: [], following: [], posts: []);
      await _users.doc(username).set(user.toMap());
      UserModel us=user;
      us.name="";
      await _users.doc(cred.user?.uid).set(us.toMap());
      
      return right(user);

    }
    catch (e) {
       return left(Failure(message: "Failed!"));
    }
  }
  FutureEither<UserModel> login(String username,String password)async {
    try {
       _users.doc(username).get().then((value){
         if(!value.exists) throw 'User doesnot exists.'; 
         else{
          user=UserModel.fromDocumentSnapshot(value);
         }
         });
     await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: user.email,
      password: password,
    );
    return right(user);
  } on FirebaseAuthException catch (e){
      throw "Wrong Password!";
    }
    catch (e) {
       return left(Failure(message: e.toString()));
    }
  }
  Stream<UserModel> getUserData(String uid) {
    
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
  FutureEither<String> logOut() async {
  try {
    await _auth.signOut();
    return right("Successfully logout");
  } on FirebaseAuthException catch (e){
      throw "LogOut failed!";
    }
    catch (e) {
       return left(Failure(message: e.toString()));
    }
}
}