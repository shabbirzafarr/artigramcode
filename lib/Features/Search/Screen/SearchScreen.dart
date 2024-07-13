import 'package:artplace/Features/Search/Screen/Screen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen();
  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.sizeOf(context).width;
    return Scaffold(
      
      body: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: (){
                showSearch(
              context: context,
              delegate: SearchUserDelegate(),
            );
              },
              child: Container(margin: EdgeInsets.all(10),decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey), height: 50,width: width-20,child: Row(
                children: [
                  SizedBox(width: 5,),
                  Icon(Icons.search),
                  SizedBox(width: 5,),
                  Text("Search"),
                ],
              ),)),
              
          ],
        
        ),
      ),
    );
  }
}