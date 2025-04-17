import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../export.dart';

class OtpVerificationController extends GetxController {
  TextEditingController otpTextController = TextEditingController();
  FocusNode otpFocusNode = FocusNode();
  final GetStorage box = GetStorage();
  DatabaseManager databaseManager = DatabaseManager();

  Timer? timer;
  RxInt start = 30.obs;
  RxString secondsStr = '00:30'.obs;

  bool isFromForgot = false;
  bool? isFromSignup = false;

  String contactNumber = "";
  String emailTxt = "";
  String? verificationId;

  // Additional user details
  String fullName = "";
  String profilePicUrl = "";
  String userName = "";
  String phoneNsn = "";
  String countryCode = "";
  String guid = "";

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

  void getArguments() {
    var arguments = Get.arguments;

    if (arguments.isNotEmpty) {
      contactNumber = arguments["phoneNumber"] ?? "";
      verificationId = arguments["verificationId"];
      emailTxt = arguments["email"] ?? "";
      isFromSignup = arguments["isForSignUp"] ?? false;
      guid = arguments["guid"] ?? "";

      // Optional data
      fullName = arguments["fullName"] ?? "";
      profilePicUrl = arguments["profilePicUrl"] ?? "";
      userName = arguments["userName"] ?? "";
      phoneNsn = arguments["phoneNsn"] ?? "";
      countryCode = arguments["countryCode"] ?? "";
      print("All arguments received: $arguments and $contactNumber");
    }
    update();
  }

  void startTimer() {
    timer = Timer.periodic(
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
    print("otpTextController.text.isNotEmpty: ${otpTextController.text.isNotEmpty}");
    print("otpTextController.text.isNotEmpty: ${otpTextController.text}");
    if (otpTextController.text.length < 1) {
      Fluttertoast.showToast(msg: "Otp is required");
      return;
    }
    try {
      EasyLoading.show();
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpTextController.text,
      );
      var user = await FirebaseAuth.instance.signInWithCredential(credential);
      await box.write("uid", user.user?.uid);
      if(isFromSignup ?? false){
        await databaseManager.addUser(
            fullName: fullName,
            email: emailTxt,
            uuid: "${user.user?.uid}",
            profilePicUrl: 'https://picsum.photos/200/300',
            userName: userName,
            method: user.credential?.signInMethod ?? "",
            isForUpdate: false,
            phoneNumber: phoneNsn,
            countryCode: countryCode, guid: guid);
      }
      Get.offAndToNamed(AppRoutes.homeRoute);
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Otp Verification Successful!");
    } catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Otp Verification Failed: $e");
    }
  }

  void resendOtp() async {
    print("contactNumber: $contactNumber");
    if (contactNumber.isEmpty) {
      Fluttertoast.showToast(msg: "Phone number is missing.");
      return;
    }

    start.value = 30;
    secondsStr.value = '00:30';
    startTimer(); // restart timer

    String fullPhoneNumber = contactNumber;
    print("fullPhoneNumber: $fullPhoneNumber");
    try {
      EasyLoading.show(status: 'Resending OTP...');
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) {
          // Optional: auto sign-in on Android devices
        },
        verificationFailed: (FirebaseAuthException e) {
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: "Verification Failed: ${e.message}");
        },
        codeSent: (String newVerificationId, int? resendToken) {
          verificationId = newVerificationId;
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: "OTP Resent Successfully");
          update();
        },
        codeAutoRetrievalTimeout: (String newVerificationId) {
          verificationId = newVerificationId;
        },
      );
    } catch (e) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: "Error resending OTP: $e");
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
