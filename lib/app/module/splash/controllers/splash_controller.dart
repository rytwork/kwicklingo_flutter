import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

import '../../../export.dart';

class SplashController extends GetxController {
  var timer;
  // RxString currentLogo = iconsSplashIcon.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetStorage box = GetStorage();


  @override
  void onInit() {
    _navigateToNextScreen();
    super.onInit();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  //*===================================================================== Check App validity ==========================================================*
  void _navigateToNextScreen() =>
      timer = Timer(const Duration(seconds: 3, milliseconds: 500), () async {
        var userId = await box.read("uid");
        print("userId: $userId");
        if (userId == null) {
          Get.offAndToNamed(AppRoutes.signupRoute);
        } else {
          Get.offAndToNamed(AppRoutes.homeRoute);
        }
      });
}

