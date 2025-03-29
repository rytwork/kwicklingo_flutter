import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../export.dart';

class SignInController extends GetxController {
  RxBool viewPassword = true.obs;

  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  // DatabaseManager databaseManager = DatabaseManager();

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
          Get.offAndToNamed(AppRoutes.homeRoute);
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
