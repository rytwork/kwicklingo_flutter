import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../../export.dart';

class SignUpController extends GetxController {
  RxBool viewPassword = true.obs;
  RxBool confirmViewPassword = true.obs;
  String? verificationId;
  bool isOtpSent = false;

  TextEditingController nameTextController = TextEditingController();
  TextEditingController useNameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController confirmPasswordTextController = TextEditingController();
  DatabaseManager databaseManager = DatabaseManager();

  FocusNode? nameFocusNode = FocusNode();
  FocusNode? userNameFocusNode = FocusNode();
  FocusNode? emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();
  var isIgnoreInteraction = false;


  PhoneController phoneFieldController = PhoneController();
  FocusNode phoneFieldFocusNode = FocusNode();
  CountrySelectorNavigator selectorNavigator = const CountrySelectorNavigator.page();
  bool withLabel = true;
  bool outlineBorder = true;
  bool isCountryButtonPersistant = false;
  bool mobileOnly = false;
  // Locale locale = Locale('en', 'US');


  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    passwordTextController.dispose();
    confirmPasswordTextController.dispose();
    super.dispose();
  }

  signUp() async {
    if (emailTextController.text.trim().isNotEmpty &&
        passwordTextController.text.trim().isNotEmpty && phoneFieldController.value.nsn.trim().isNotEmpty) {
      EasyLoading.show();
      isIgnoreInteraction = true;
      update();
      try {
        final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim(),
        );
        if (credential.user != null) {
          sendOtp("+${phoneFieldController.value.countryCode}${phoneFieldController.value.nsn}");
          databaseManager.addUser(
              fullName: nameTextController.text,
              email: emailTextController.text,
              uuid: "${credential.user?.uid}",
              profilePicUrl: 'https://picsum.photos/200/300',
              userName: useNameTextController.text,
              method: credential.credential?.signInMethod ?? "",
              isForUpdate: false, phoneNumber: '', countryCode: '');
          EasyLoading.dismiss();
          ToastUtils.showToast("The account has been successfully created.");
          // Get.offAndToNamed(AppRoutes.homeRoute);
        } else {
          EasyLoading.dismiss();
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          EasyLoading.dismiss();
          ToastUtils.showToast("The password provided is too weak.");
        } else if (e.code == 'email-already-in-use') {
          ToastUtils.showToast("The account already exists for that email.");
        } else {
          EasyLoading.dismiss();
          ToastUtils.showToast("${e.message}");
        }
      } catch (e) {
        EasyLoading.dismiss();
        ToastUtils.showToast('Exception: $e');
      } finally{
        isIgnoreInteraction = false;
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
        Fluttertoast.showToast(msg: "MFA linked successfully!");
      },
      verificationFailed: (FirebaseAuthException e) {
        Fluttertoast.showToast(msg: "Verification Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId = verificationId;
        isOtpSent = true;
        update();
        print("phoneNumber $phoneNumber and verificationId $verificationId");
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

  PhoneNumberInputValidator getValidator(BuildContext context) {
    List<PhoneNumberInputValidator> validators = [];
    if (mobileOnly) {
      validators.add(PhoneValidator.validMobile(context));
    } else {
      validators.add(PhoneValidator.valid(context));
    }
    validators.add((phoneNumber) {
      if (phoneNumber == null) {
        return 'Phone number cannot be empty';
      }
      return null;
    });
    return PhoneValidator.compose(validators);
  }



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
  //     isIgnoreInteraction = true;
  //     update();
  //     var userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //     if (userCredential.user != null) {
  //       await databaseManager.checkSocialUserRegister(userCredential);
  //       EasyLoading.dismiss();
  //       isIgnoreInteraction = false;
  //       update();
  //       Get.offAllNamed(AppRoutes.homeRoute);
  //     }
  //   } catch (e) {
  //     ToastUtils.showToast('Failed to sign in with Google: $e');
  //   }finally{
  //     isIgnoreInteraction = false;
  //     EasyLoading.dismiss();
  //     update();
  //   }
  // }


}
