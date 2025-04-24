import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../export.dart';
import 'dart:convert';

class HomepageController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var animationValue = 0.0.obs;
  DatabaseManager databaseManager = DatabaseManager();
  final GetStorage box = GetStorage();

  // Make userData observable
  final Rxn<Map<String, dynamic>> userData = Rxn<Map<String, dynamic>>();

  @override
  Future<void> onInit() async {
    await getUserData();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: false);

    animationController.addListener(() {
      animationValue.value = animationController.value;
    });

    super.onInit();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  Future<void> getUserData() async {
    var userId = await box.read("uid");
    if (userId != null) {
      userData.value = await databaseManager.getUserOfPhoneUser(userId);
      print("userData: ${userData.value?["name"]}");
    }
  }


  Future<void> getAgoraToken() async {
    try {
      final url = Uri.parse('https://api-g2h54slc7q-uc.a.run.app/api/token/getOrCreateAgoraToken');

      var userId = await box.read("uid");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "uid": userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final channelName = data['channelName'];

        Get.toNamed(AppRoutes.videoCallScreen, arguments: {
          "token": token,
          "channelName": channelName
        });

        print('Agora Token: $token');
        print('Channel Name: $channelName');
      } else {
        print('Failed to get token. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        Fluttertoast.showToast(msg: "Failed to get token: ${response.body}");
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: "An error occurred: $e");
    }
  }


  Future<void> logoutUser() async {
    Get.defaultDialog(
      title: "Logout Confirmation",
      middleText: "Are you sure you want to logout?",
      textCancel: "Cancel",
      textConfirm: "Logout",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back(); // close the dialog
        EasyLoading.show();
        try {
          await FirebaseAuth.instance.signOut();
          await box.remove("uid");
          Get.offAllNamed(AppRoutes.splashRoute);
          EasyLoading.dismiss();
        } catch (e) {
          Fluttertoast.showToast(msg: "Logout Failed: $e");
          print("Error logging out: ${e.toString()}");
          EasyLoading.dismiss();
        }
      },
    );
  }


  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
