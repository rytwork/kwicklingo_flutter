import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../export.dart';

class ForgotPasswordController extends GetxController {

  TextEditingController emailTextController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();

  Future<void> resetPassword() async {
    EasyLoading.show();
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailTextController.text.trim());
      showCustomDialog();
    } on FirebaseAuthException catch (e) {
      String error = "Something went wrong.";
      if (e.code == 'user-not-found') {
        error = "No user found for that email.";
      }
      ToastUtils.showToast(error);
    } finally {
     EasyLoading.dismiss();
    }
  }



  void showCustomDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: height_5),
              AssetSVGImageWidget(iconsForgotDialogIcon),
              Text(
                strCheckEmail,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                strForgotDialogDes,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: () {
                  Get.back(); // Close the dialog
                },
                color: AppColors.affair,
                child: TextView(text: strDone,textStyle: textStyleBodyLarge().copyWith(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
