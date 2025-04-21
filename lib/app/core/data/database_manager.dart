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
    required String guid,
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
              'guid': guid,
              'profilePicUrl': profilePicUrl,
              'method': method,
              'phoneNumber': phoneNumber,
              'countryCode': countryCode
            })
          : await db.collection('users').doc(uuid).set({
              'name': fullName,
              'userName': userName,
              'email': email,
              'guid': guid,
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

  Future<Map<String, dynamic>?> getUser(String uuid) async {
    try {
      QuerySnapshot query = await db
          .collection('users')
          .where('guid', isEqualTo: uuid)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        DocumentSnapshot doc = query.docs.first;
        if (doc.exists) {
          return doc.data() as Map<String, dynamic>;
        } else {
          print("No user found with uuid: $uuid");
          return null;
        }
      } else {
        print('No user found with the given guid.');
      }
    } catch (e) {
      print("Error getting user: ${e.toString()}");
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserOfPhoneUser(String uuid) async {
    try {
      DocumentSnapshot doc = await db.collection('users').doc(uuid).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        print("No user found with uuid: $uuid");
        return null;
      }
    } catch (e) {
      print("Error getting user: ${e.toString()}");
      return null;
    }
  }


  Future<void> addToWaitingUsers(String userId) async {
    DocumentReference docRef = db.collection("connections").doc("waiting-users");

    try {
      print("Attempting to add user ID $userId to waiting-users...");
      await docRef.update({
        "ids": FieldValue.arrayUnion([userId]),
      });
      print("User ID $userId added successfully!");
    } on FirebaseException catch (e) {
      if (e.code == 'not-found') {
        print("Document not found. Creating new document...");
        await docRef.set({
          "ids": [userId]
        });
        print("Document created and User ID $userId added.");
      } else {
        print("FirebaseException: ${e.message}");
      }
    } catch (e) {
      print("General error: $e");
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
