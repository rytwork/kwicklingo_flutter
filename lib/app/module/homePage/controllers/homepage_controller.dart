import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import '../../../export.dart';

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
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      userData.value = await databaseManager.getUserOfPhoneUser(currentUser.uid);
      print("userData: ${userData.value?["name"]}");
    }
  }

  Future<void> logoutUser() async {
    EasyLoading.show();
    try {
      await FirebaseAuth.instance.signOut();
      await box.remove("uid");
      Get.offAllNamed(AppRoutes.splashRoute);
      EasyLoading.dismiss();
    } catch (e) {
      Fluttertoast.showToast(msg: "Otp Verification Failed: $e");
      print("Error logging out: ${e.toString()}");
      EasyLoading.dismiss();
    }
  }

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
