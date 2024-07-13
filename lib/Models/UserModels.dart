

import 'package:flutter/foundation.dart';

import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
  String name;
  String username;
  String email;
  String profilePic;
  List<dynamic> followers;
  List<dynamic> following;
  List<dynamic> posts;

  UserModel({
    required this.name,
    required this.username,
    required this.email,
    required this.profilePic,
    required this.followers,
    required this.following,
    required this.posts,
  });
  
  // Additional methods or constructors can be added as needed

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    return UserModel(
      name: data?['name'] ?? '',
      username: data?['username'] ?? '',
      email: data?['email'] ?? '',
      profilePic: data?['profilePic'] ?? '',
      followers: List<dynamic>.from(data?['followers'] ?? []),
      following: List<dynamic>.from(data?['following'] ?? []),
      posts: List<dynamic>.from(data?['posts'] ?? []),
    );
  }

  

  UserModel copyWith({
    String? name,
    String? username,
    String? email,
    String? profilePic,
    List<dynamic>? followers,
    List<dynamic>? following,
    List<dynamic>? posts,
  }) {
    return UserModel(
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'username': username,
      'email': email,
      'profilePic': profilePic,
      'followers': followers,
      'following': following,
      'posts': posts,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String ?? "",
      username: map['username'] as String ?? "",
      email: map['email'] as String ?? "",
      profilePic: map['profilePic'] as String,
      followers: List<dynamic>.from(map['followers'] ),
      following: List<dynamic>.from(map['following'] ),
      posts: List<dynamic>.from(map['posts']),
    );
  }

  

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.username == username &&
      other.email == email &&
      other.profilePic == profilePic &&
      listEquals(other.followers, followers) &&
      listEquals(other.following, following) &&
      listEquals(other.posts, posts);
  }

  @override
  int get hashCode {
    return name.hashCode ^
      username.hashCode ^
      email.hashCode ^
      profilePic.hashCode ^
      followers.hashCode ^
      following.hashCode ^
      posts.hashCode;
  }
}
