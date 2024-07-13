import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class FirebaseProvidor{
  static final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
static final authProvider = Provider((ref) => FirebaseAuth.instance);
static final storageProvider = Provider((ref) => FirebaseStorage.instance);
}
