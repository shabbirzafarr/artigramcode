import 'package:artplace/Core/Utils/Loader.dart';
import 'package:artplace/Features/Authentication/Controller/AuthController.dart';
import 'package:artplace/Features/Post/Controller/PostController.dart';
import 'package:artplace/Features/Post/Widget/PostPageView.dart';
import 'package:artplace/Models/Post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  void refreshPosts(){
    ref.read(postControllerProvider);
     ref.read(postControllerProvider.notifier).getallpost(context);

  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postProvidor);
    final isLoading=ref.read(postControllerProvider);
    

    return Scaffold(
      appBar: AppBar(title: Text("Artigram"),),
      body: RefreshIndicator(
        onRefresh: () async {
          refreshPosts();
        },
        child:(isLoading)?Loader(): Consumer(
        builder: (context, ref, _) {
           
            if (posts!.isEmpty) {
              return Center(child: Text('No Post..'));
            } else {
              return ListView.builder(
                itemCount: posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == posts.length) {
                    return Center(child: Text('All content displayed.'));
                  } else {
                    return PostCard(post: posts[index]);
                  }
                },
              );
            }
          },
          
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> PostPage(post.id)));
      },
      child: Card(
        
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(post.imageUrl),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(post.title),
            ),
          ],
        ),
      ),
    );
  }
}
