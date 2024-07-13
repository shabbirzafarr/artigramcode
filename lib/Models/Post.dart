// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class Post {
  final String id;
  final String username;
  final String title;
  final String caption;
  final String imageUrl; // Added image link
  final DateTime createdAt;
  final List<dynamic> upvotes;
  final List<dynamic> downvotes;
  final List<dynamic> comments;

  Post({
    required this.id,
    required this.username,
    required this.title,
    required this.caption,
    required this.imageUrl,
    required this.createdAt,
    required this.upvotes,
    required this.downvotes,
    required this.comments
  });

  factory Post.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return Post(
      id: snapshot.id,
      username: data['username'],
      title: data['title'],
      caption: data['caption'],
      imageUrl: data['imageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      upvotes: List<dynamic>.from(data['upvotes']),
      downvotes: List<dynamic>.from(data['downvotes']),
      comments: List<dynamic>.from(data['comments']),
    );
  }

  Post copyWith({
    String? id,
    String? username,
    String? title,
    String? caption,
    String? imageUrl,
    DateTime? createdAt,
    List<dynamic>? upvotes,
    List<dynamic>? downvotes,
    List<dynamic>? comments,
  }) {
    return Post(
      id: id ?? this.id,
      username: username ?? this.username,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'title': title,
      'caption': caption,
      'imageUrl': imageUrl,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'comments': comments,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      username: map['username'] as String,
      title: map['title'] as String,
      caption: map['caption'] as String,
      imageUrl: map['imageUrl'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      upvotes: List<dynamic>.from(map['upvotes'] as List<dynamic>),
      downvotes: List<dynamic>.from(map['downvotes'] as List<dynamic>),
      comments: List<dynamic>.from(map['comments'] as List<dynamic>),
    );
  }

  

  @override
  bool operator ==(covariant Post other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.username == username &&
      other.title == title &&
      other.caption == caption &&
      other.imageUrl == imageUrl &&
      other.createdAt == createdAt &&
      listEquals(other.upvotes, upvotes) &&
      listEquals(other.downvotes, downvotes) &&
      listEquals(other.comments, comments);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      title.hashCode ^
      caption.hashCode ^
      imageUrl.hashCode ^
      createdAt.hashCode ^
      upvotes.hashCode ^
      downvotes.hashCode ^
      comments.hashCode;
  }
}
