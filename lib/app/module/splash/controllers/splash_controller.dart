import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../export.dart';

class SplashController extends GetxController {
  var timer;
  // RxString currentLogo = iconsSplashIcon.obs;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        User? user = _auth.currentUser;
        if (user == null) {
          Get.offAndToNamed(AppRoutes.signupRoute);
        } else {
          Get.offAndToNamed(AppRoutes.homeRoute);
        }
      });
}

