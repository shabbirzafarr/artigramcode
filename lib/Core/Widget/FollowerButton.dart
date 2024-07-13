import 'package:artplace/Features/Authentication/Controller/AuthController.dart';
import 'package:artplace/Features/UserProfile.dart/Controller/UserProfileController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowButton extends ConsumerWidget {
  final String uid;

  const FollowButton(this.uid);
  void Follow(BuildContext context,WidgetRef ref) async
  {
    final user=ref.watch(userProvider);
    ref.watch(userProfileControllerProvider.notifier).FollowButton(context,user!.username , uid,ref);
  }

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return ElevatedButton(
      onPressed: (){
        Follow(context,ref);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_add,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Follow',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}