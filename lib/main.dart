import 'package:artplace/Core/Constants/FirebaseConstant.dart';
import 'package:artplace/Core/Utils/ErrorText.dart';
import 'package:artplace/Core/Utils/Loader.dart';
import 'package:artplace/Features/Post/Controller/PostController.dart';
import 'package:artplace/Models/UserModels.dart';
import 'package:artplace/Router.dart';
import 'package:artplace/Theme/Pallete.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import 'Features/Authentication/Controller/AuthController.dart';
void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;
  void getData(WidgetRef ref, User data) async {
    final user=await FirebaseFirestore.instance.collection(FirebaseConstants.usersCollection).doc(data.uid).snapshots().first;
    final username=UserModel.fromDocumentSnapshot(user).username;
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(username)
        .first;
    print(userModel);
    ref.read(userProvider.notifier).update((state) => userModel);
    ref.read(postControllerProvider.notifier).getallpost(context);
    
  }
  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(data: (data)=> MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Reddit Tutorial',
            theme: ref.watch(themeNotifierProvider)
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            ,
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (data != null) {
                  getData(ref, data);
                  return loggedInRoute;
                }
                return loggedOutRoute;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
            ),
    error: (error, stackTrace) =>  ErrorText(error: error.toString()),
    loading: ()=>Loader());
  }
}