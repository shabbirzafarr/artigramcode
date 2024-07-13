
import 'package:artplace/Core/Utils/Loader.dart';

import 'package:artplace/Core/Widget/UserListTile.dart';
import 'package:artplace/Features/Authentication/Controller/AuthController.dart';
import 'package:artplace/Features/Post/Controller/PostController.dart';
import 'package:artplace/Features/Post/Widget/InstagramPosttile.dart';
import 'package:artplace/Features/Post/Widget/PostPageView.dart';
import 'package:artplace/Features/UserProfile.dart/Screen/EditProfile.dart';
import 'package:artplace/Features/UserProfile.dart/Screen/ProfileSetting.dart';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Core/Utils/ErrorText.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen();

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.sizeOf(context).height;
    double safeAreaHeight = MediaQuery.of(context).padding.top;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 200+safeAreaHeight,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: ProfileHeader(),
                ),
              ),
              SliverPersistentHeader(
                
                delegate: _SliverAppBarDelegate(
                  TabBar(
                               
                    
                    tabs: [
                      Tab(
                       
                        icon: Icon(Icons.grid_on_outlined),
                      ),
                      Tab(
                        
                        icon: Icon(Icons.people),
                      ),
                      Tab(
                        
                        icon: Icon(Icons.person_add),
                      ),
                      Tab(
                        
                        icon: Icon(Icons.settings),
                      ),
                    ],
                    dividerHeight: 0,
                     
                           
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              isScrollable: false,
                              indicatorSize: TabBarIndicatorSize.label,
                              indicator: UnderlineTabIndicator(borderRadius: BorderRadius.circular(10)),
                              
                  ),
                ),
                pinned: true,
              
                
                
              ),
            ];
          },
          body: TabBarView(
            children: [
              ProfileTabContent('Posts'),
              ProfileTabContent('Followers'),
              ProfileTabContent('Following'),
              ProfileTabContent('Settings'),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class ProfileTabContent extends StatelessWidget {
  final String tabName;

  ProfileTabContent(this.tabName);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (tabName == 'Posts') ...[
            ProfileStats(),
            // Add your posts content here
          ] else if (tabName == 'Followers') ...[
            ProfileFollowers(),
            // Add your followers content here
          ] else if (tabName == 'Following') ...[
            ProfileFollowing(),
            // Add your following content here
          ] else if (tabName == 'Settings') ...[
            ProfileSettings(),
            // Add your settings content here
          ],
        ],
      ),
    );
  }
}

class ProfileHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double safeAreaHeight = MediaQuery.of(context).padding.top;
    return Container(
      margin: EdgeInsets.only(top: safeAreaHeight),
      child: Consumer(
        builder: (context, ref, _) {
          final user = ref.watch(userProvider);
          final check=(user!.profilePic.length)==0;
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Profile",style: TextStyle(fontSize: 24),),
                SizedBox(height: 5,),
                Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                (check)?
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/logo.png")// Add a real image URL
                ):
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(user.profilePic)// Add a real image URL
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text(
                      user.username,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.name,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfileScreen()));
                        // Handle the edit profile button press
                        // Navigate to the edit profile screen or show a modal, etc.
                      },
                      child: Text('Edit Profile'),
                    ),
                  ],
                ),
                Column(
                  
                  children: [
                    SizedBox(height: 15,),
                    Text("Follower : ${user.followers.length}"),
                    SizedBox(height: 5,),
                    Text("Following : ${user.following.length}"),
                    SizedBox(height: 5,),
                    Text("Posts : ${user.posts.length}")
                  ],
                )
              ],
            ),
              ],
            )
          );
        },
      ),
    );
  }
}

class ProfileStats extends ConsumerWidget {
  void NavigateToPost(BuildContext context, String uid){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>PostPage(uid)));
  }
  
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user=ref.watch(userProvider);
    return Container(
      height: 600,
      child: GridView.builder(
        
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // You can change the number of columns here
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: user!.posts.length,
        itemBuilder: (context, index) {
          
          return ref.watch(getPostByIdProvider(user.posts[index])).when(data: (data)=> 
          InkWell(onTap: ()=>NavigateToPost(context,data.id) , child: InstagramPost(imagePath: data.imageUrl)), 
          error: (error, stackTrace) =>  ErrorText(error: "Loading!"), loading: ()=>Loader());
        },
      ),
    );
  }

  
}

class ProfileFollowers extends ConsumerWidget{
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final user=ref.watch(userProvider);
    return (user!.followers==[])?Center(child: Text("Fuckoff",style: TextStyle(color: Colors.white),)):
    Container(
      height: 600,
      child: ListView.builder(itemCount:user!.followers.length , itemBuilder: (context, index) {
        return userListTile(user.followers[index]);
      }),
    );
  }
}

class ProfileFollowing extends ConsumerWidget {
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    // Add your following content here
    final user=ref.watch(userProvider);
    print(user!.toMap());
    return (user.following==[])?Center(child: Text("Fuckoff",style: TextStyle(color: Colors.white),)):Container(
      height: 600,
      child: ListView.builder(scrollDirection: Axis.vertical, itemCount:user.following.length , itemBuilder: (context, index) {
        return userListTile(user.following[index]);
      }),
    );
  }
}

