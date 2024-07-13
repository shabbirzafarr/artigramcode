import 'package:artplace/Core/Utils/ErrorText.dart';
import 'package:artplace/Core/Utils/Loader.dart';
import 'package:artplace/Core/Widget/FollowerButton.dart';
import 'package:artplace/Core/Widget/RemoveFollowerButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Features/Authentication/Controller/AuthController.dart';
import '../../Features/UserProfile.dart/Controller/UserProfileController.dart';

class UserListTitle extends ConsumerStatefulWidget {
  final String query;
  const UserListTitle(this.query);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserListTitleState();
}

class _UserListTitleState extends ConsumerState<UserListTitle> {
  @override
  Widget build(BuildContext context) {
    final checkFollower=ref.watch(userProvider);
      return ref.watch(searchUserProvider(widget.query)).when(
        data: (users) => ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/logo.png"),
                ),
                title: Text('${user.username.toString()}'),
                subtitle: Text('${user.name}'),
                trailing: (checkFollower!.following.contains(user.username))?UnfollowButton(user.username):FollowButton(user.username)
                
              );
            },
          ),
      error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
       loading: ()=> Loader());
    }
}
