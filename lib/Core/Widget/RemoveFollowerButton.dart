import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Features/Authentication/Controller/AuthController.dart';
import '../../Features/UserProfile.dart/Controller/UserProfileController.dart';

class UnfollowButton extends ConsumerWidget {
  final String uid;
  const UnfollowButton(this.uid);
  void Follow(BuildContext context,WidgetRef ref) async
  {
    try{
      final user=ref.watch(userProvider);
    ref.watch(userProfileControllerProvider.notifier).FollowingButton(context,user!.username , uid,ref);
    }catch(e){
      print(e.toString());
    }
    
  }
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return ElevatedButton(
      onPressed: (){Follow(context, ref);},
      style: ElevatedButton.styleFrom(
        primary: Colors.grey,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_remove,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Unfollow',
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