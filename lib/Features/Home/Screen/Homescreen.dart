import 'package:artplace/Features/Home/Screen/HomePage.dart';
import 'package:artplace/Features/Post/Screen/addImage.dart';
import 'package:artplace/Features/Post/Widget/PostPageView.dart';

import 'package:artplace/Features/Search/Screen/SearchScreen.dart';
import 'package:artplace/Features/UserProfile.dart/Screen/ProfilePage.dart';
import 'package:artplace/Features/UserProfile.dart/Screen/ProfileScreen.dart';
import 'package:artplace/Theme/Pallete.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages=[HomePage(),SearchScreen(),AddPostPage(),ProfileScreen()];
  int _page=0;
void onPageChanged(int page){
  setState(() {
    _page=page;
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Pallete.darkModeAppTheme.iconTheme.color,
        backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
        items: const [
          BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.home),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(CupertinoIcons.search,),
                  ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.add),
                  ),
                  label: '',
                ),
                
                
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.person),
                  ),
                  label: '',
                ),
                
      ],onTap: onPageChanged,
              currentIndex: _page,
      ),
      
    );
  }
}