import 'package:artplace/Features/Authentication/Repositories/Repo.dart';
import 'package:artplace/Features/Home/Screen/HomePage.dart';
import 'package:artplace/Features/Home/Screen/Homescreen.dart';
import 'package:artplace/Models/Post.dart';
import 'package:artplace/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../Core/Utils/Snackbar.dart';
import '../../../Models/UserModels.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);
final postProvidor= StateProvider<List<Post>?>((ref) => []);
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(AuthRepositoryProvider),
    ref: ref,
  ),
);
final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});
final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // loading
  void updateUserProvider()async{
    final userp=await _authRepository.getUserData(_ref.read(userProvider)!.username).first;
    _ref.read(userProvider.notifier).update((state) => userp);
  }
  void signIn(BuildContext context, String username, String password) async {
    state = true;
    final user = await _authRepository.login(username, password);
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
   
    }
    Stream<User?> get authStateChange => _authRepository.authStateChange;
     void signUp(BuildContext context, String name, String email,
        String username, String password) async {
      state = true;
      final user =
          await _authRepository.createAccount(email, password, name, username);
      state = false;
      user.fold(
        (l) {},
        (r) {
          Navigator.pop(context);
          _ref.read(userProvider.notifier).update((state) => r);
          
        },
        
            
      );
        }

    Stream<UserModel> getUserData(String uid) {
      return _authRepository.getUserData(uid);
    }

    void logout() async {
      _authRepository.logOut();
    }
  }

