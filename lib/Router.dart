import 'package:artplace/Features/Authentication/Pages/Login.dart';
import 'package:artplace/Features/Authentication/Pages/Signup.dart';
import 'package:artplace/Features/Search/Screen/Screen.dart';
import 'package:artplace/Features/Search/Screen/SearchScreen.dart';
import 'package:artplace/Features/UserProfile.dart/Screen/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import 'Features/Home/Screen/Homescreen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginPage()),
  
});
final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child:HomeScreen()),
    '/SearchScreen': (_) => const MaterialPage(child: HomeScreen()),
  }
);