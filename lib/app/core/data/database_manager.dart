import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class DatabaseManager {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> addUser({
    required String fullName,
    required String userName,
    required String email,
    required String profilePicUrl,
    required String uuid,
    required String method,
    required String phoneNumber,
    required String countryCode,
    required bool isForUpdate,
  }) async {
    print("object");
    try {
      isForUpdate
          ? await db.collection('users').doc(uuid).update({
              'name': fullName,
              'userName': userName,
              'email': email,
              'profilePicUrl': profilePicUrl,
              'method': method,
              'phoneNumber': phoneNumber,
              'countryCode': countryCode
            })
          : await db.collection('users').doc(uuid).set({
              'name': fullName,
              'userName': userName,
              'email': email,
              'profilePicUrl': profilePicUrl,
              'method': method,
              'phoneNumber': phoneNumber,
              'countryCode': countryCode
            });
      return 'success';
    } catch (e) {
      print("Error adding user: ${e.toString()}");
      return e.toString();
    }
  }


  Future<void> addToWaitingUsers(String userId) async {
    try {
      DocumentReference docRef = db.collection("connections").doc("waiting-users");

      // Ensure document exists
      await docRef.set({"ids": []}, SetOptions(merge: true));

      // Update Firestore document by adding the new user ID
      await docRef.update({
        "ids": FieldValue.arrayUnion([userId]),
      });

      print("User ID $userId added successfully!");
    } catch (e) {
      print("Error adding user ID: $e");
    }
  }


  Future<String?> removeFromWaitingList({
    required String uid,
  }) async {
    try {
      await db.collection('connections').doc('waiting-users').update({
        'id': FieldValue.arrayRemove([uid]),
      });
      return 'success';
    } catch (e) {
      print("Error removing user: ${e.toString()}");
      return e.toString();
    }
  }

  Future uploadFile(String img) async {
    File? _photo;
    _photo = File(img);
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'images/$fileName';
    try {
      final ref = storage.ref(destination).child('images/');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  Future<User?> getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }


}
