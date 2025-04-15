import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import '../../../export.dart';

class SignInController extends GetxController {
  RxBool viewPassword = true.obs;
  final GetStorage box = GetStorage();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  DatabaseManager databaseManager = DatabaseManager();
  String? verificationId;
  bool isOtpSent = false;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  var isLoggedIn = true;


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    //TODO Remove this while making build
    super.onReady();
  }

  @override
  void dispose() {
    emailTextController.dispose();
    passwordTextController.dispose();
    super.dispose();
  }

  signIn() async {
    if (emailTextController.text.trim().isNotEmpty && passwordTextController.text.trim().isNotEmpty) {
      EasyLoading.show();
      isLoggedIn = false;
      update();
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim(),
        );
        if (credential.user != null) {
          var userData = await databaseManager.getUser('${credential.user?.uid}');
          if (userData != null) {
            sendOtp("+${userData['countryCode']}${userData['phoneNumber']}");
          } else {
            print("User not found.");
          }
          EasyLoading.dismiss();
          isLoggedIn = true;
          update();
        } else {
          EasyLoading.dismiss();
          ToastUtils.showToast("The account has been successfully created.");
          isLoggedIn = true;
          update();
        }
      } on FirebaseAuthException catch (e) {
        ToastUtils.showToast("${e.message}");
      } catch (e) {
        ToastUtils.showToast("$e");
      } finally{
        isLoggedIn = true;
        EasyLoading.dismiss();
        update();
      }
    } else {
      ToastUtils.showToast(strFillAllRequired);
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: "Verification Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        isOtpSent = true;
        update();
        Fluttertoast.showToast(msg: "OTP sent to $phoneNumber");
        Get.toNamed(AppRoutes.otpVerificationScreen, arguments: {
          "verificationId": verificationId,
          "phoneNumber": phoneNumber
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
    );
  }



  //
  //
  // signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //     if (googleAuth == null) {
  //       throw Exception('Google authentication failed');
  //     }
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //     EasyLoading.show();
  //     isLoggedIn = false;
  //     update();
  //     var userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //     if (userCredential.user != null) {
  //       await databaseManager.checkSocialUserRegister(userCredential);
  //       EasyLoading.dismiss();
  //       isLoggedIn = true;
  //       update();
  //       Get.offAllNamed(AppRoutes.homeRoute);
  //     }
  //   } catch (e) {
  //     print(e);
  //     ToastUtils.showToast('Failed to sign in with Google: $e');
  //   }finally{
  //     isLoggedIn = true;
  //     EasyLoading.dismiss();
  //     update();
  //   }
  // }
  //
  //
  // void signInWithFacebook() async {
  //   try {
  //     final LoginResult loginResult = await FacebookAuth.instance.login();
  //     final OAuthCredential facebookAuthCredential = FacebookAuthProvider
  //         .credential(loginResult.accessToken!.tokenString);
  //     EasyLoading.show();
  //     isLoggedIn = false;
  //     update();
  //     var userCredential = await FirebaseAuth.instance.signInWithCredential(
  //         facebookAuthCredential);
  //     if (userCredential.user != null) {
  //       await databaseManager.checkSocialUserRegister(userCredential);
  //       EasyLoading.dismiss();
  //       isLoggedIn = true;
  //       update();
  //       Get.offAllNamed(AppRoutes.homeRoute);
  //     }
  //   } catch (e) {
  //     ToastUtils.showToast("Firebase Auth Error: $e");
  //   }finally{
  //     EasyLoading.dismiss();
  //     isLoggedIn = true;
  //     update();
  //   }
  // }




}
