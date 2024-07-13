import 'package:artplace/Core/Utils/ErrorText.dart';
import 'package:artplace/Core/Utils/Loader.dart';
import 'package:artplace/Core/Widget/FollowerButton.dart';
import 'package:artplace/Core/Widget/RemoveFollowerButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Features/Authentication/Controller/AuthController.dart';

class userListTile extends ConsumerWidget {
  final String uid;
  const userListTile(this.uid);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user=ref.watch(userProvider);
    final auser=ref.watch(getUserDataProvider.call(uid));
   return auser.when(data: (data)=> Container(
    height: 100,
    width: 100,
    
     child: Card(
      
      
            elevation: 3, // Add a shadow to the card
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              
              title: Text(
               data.username,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
              subtitle: Text(
                data.name,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.star,
                  color: Colors.white,
                ),
              ),
              trailing: (user!.following.contains(data.username))?UnfollowButton(data.username):FollowButton(data.username),
            ),
          ),
   )
   ,loading:()=>Loader(),error: (error, stackTrace) =>  ErrorText(error: error.toString()));
  
   
    
  }
}