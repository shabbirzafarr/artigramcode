import 'dart:io';

import 'package:artplace/Core/Constants/StorageRepositoryProvidor.dart';
import 'package:artplace/Core/Utils/Snackbar.dart';
import 'package:artplace/Core/typdef.dart';
import 'package:artplace/Features/Authentication/Controller/AuthController.dart';
import 'package:artplace/Models/UserModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Repository/UserProfileRepo.dart';
final searchUserProvider = StreamProvider.family((ref, String query) {
  return ref.watch(userProfileControllerProvider.notifier).searchCommunity(query);
});
final userProfileControllerProvider = StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});
class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);
   void editProfile({
    required File? profileFile,
    required BuildContext context,
    required String username,
    required String name
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    String ousername=user.username;

    
      if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.username,
        file: profileFile,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(profilePic: r),
      );
      user=user.copyWith(username: username,name: name);
      final res1=await _userProfileRepository.editProfile(user,ousername);
      res1.fold((l) => showSnackBar(context,l.message), (r) => _ref.read(authControllerProvider.notifier).updateUserProvider());
      state=false;
    }
    else{
      user=user.copyWith(username: username,name: name);
      final res1=await _userProfileRepository.editProfile(user,ousername);
      res1.fold((l) =>showSnackBar(context,l.message), (r) => _ref.read(authControllerProvider.notifier).updateUserProvider());
      state=false;
    }
    
  }
  Stream<List<UserModel>> searchCommunity(String query) {
    return _userProfileRepository.searchUser(query);
  }
  void FollowButton(BuildContext context,String pid,String uid,WidgetRef ref) async{
    final res=await _userProfileRepository.Follow(pid, uid);
    res.fold((l) =>showSnackBar(context, l.message), (r) => _ref.read(authControllerProvider.notifier).updateUserProvider());
  }
  void FollowingButton(BuildContext context,String pid,String uid,WidgetRef ref) async{
    print("fuck");
    final res=await _userProfileRepository.Following(pid, uid);
    res.fold((l) =>showSnackBar(context, l.message), (r) {
      _ref.read(authControllerProvider.notifier).updateUserProvider();
    } );
  }
}