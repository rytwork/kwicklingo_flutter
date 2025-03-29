import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../export.dart';

class OtpVerificationController extends GetxController {
  TextEditingController otpTextController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();


  Timer? timer;
  RxInt start = 30.obs;
  RxString secondsStr = '00:30'.obs;
  bool isFromForgot = false;
  String contactNumber = "";
  String emailTxt = "";
  String uniqueCode = "";
  bool? isFromSignup=false;
  String? verificationId;


  @override
  void onInit() {
    startTimer();
    getArguments();
    update();
    super.onInit();
  }


  @override
  void onReady() {
    super.onReady();
  }


  void getArguments(){
    var arguments = Get.arguments;
    if(arguments.length > 0){
      contactNumber = arguments["phoneNumber"];
      verificationId = arguments["verificationId"];
    }
    update();
  }


  void startTimer() {
    timer = new Timer.periodic(
      Duration(seconds: 1),
          (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
          update();
        } else {
          start.value--;
          secondsStr.value = '00:' + (start.value).toString().padLeft(2, '0');
          update();
        }
      },
    );

  }


  Future<void> verifyOtp() async {
    if (verificationId == null) {
      Fluttertoast.showToast(msg: "Error: Verification ID not found.");
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpTextController.text,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      Get.offAndToNamed(AppRoutes.videoCallScreen);
      Fluttertoast.showToast(msg: "MFA Verification Successful!");
    } catch (e) {
      Fluttertoast.showToast(msg: "MFA Verification Failed: $e");
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
