import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../export.dart';

class UploadProfileController extends GetxController {
  File? imageFile;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();
    }

    if (status != PermissionStatus.granted) {
      _showPermissionDeniedDialog();
      return;
    }

    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
    }
  }



  void _showPermissionDeniedDialog() {
    Get.defaultDialog(
      title: "Permission Required",
      middleText:
      "This feature requires access to your photos/camera. Please enable it in settings.",
      textCancel: "Cancel",
      textConfirm: "Open Settings",
      confirmTextColor: Colors.white,
      onConfirm: () {
        openAppSettings();  // Opens device settings for app permissions
      },
      onCancel: () {},
    );
  }

  @override
  void onInit() {
    super.onInit();
  }


  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }



  Future<String?> uploadImageToFirebase(File imageFile) async {
    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref();
      // Generate a unique file name
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final imageRef = storageRef.child("images/$fileName.jpg");
      // Upload the file
      UploadTask uploadTask = imageRef.putFile(imageFile);
      // Get the download URL
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl; // Return the image URL
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

}
