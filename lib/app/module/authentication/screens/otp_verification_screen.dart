import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import '../../../export.dart';

class OtpVerificationScreen extends StatelessWidget {
  final controller = Get.put(OtpVerificationController());
  final themeController = Get.put(ThemeController());
  final GlobalKey<FormState> otpVerifyFormGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpVerificationController>(
        init: OtpVerificationController(),
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: InkWell(
                onTap: (){
                  Get.back();
                },
                child: AssetSVGImageWidget(Assets.iconsArrow),
              ).paddingOnly(left: margin_6),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextView(
                  text: strVerifyMail,
                  textStyle: textStyleHeadlineLarge().copyWith(
                      color: themeController.isDarkMode.value == true
                          ? Colors.white
                          : Colors.black,
                      fontSize: font_22,
                      fontWeight: FontWeight.w700),
                ).paddingOnly(bottom: margin_8, top: margin_10),
                _descriptionTxt(),
                _otpTextFields(),
                _resend(),
                _verifyButton(),
              ],
            ).paddingSymmetric(horizontal: margin_20),
          );
        });
  }

  _descriptionTxt() {
    return Text.rich(
      TextSpan(
          text:
          "Enter the verification code we just sent on your phone number.",
          style: textStyleBodyLarge().copyWith(color: Colors.grey.shade700),
          children: [
            TextSpan(
                text: controller.contactNumber,
                // recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                style: textStyleTitleSmall().copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: font_12,
                    decoration: TextDecoration.underline,
                    color: AppColors.appColor)),
          ]),
    );
  }

  _otpTextFields() => Form(
    key: otpVerifyFormGlobalKey,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    child: Pinput(
      errorBuilder: (String? errorText, String pin) {
        return Row(
          children: [
            Text(
              errorText.toString(),
              textAlign: TextAlign.start,
              style: textStyleBodyMedium().copyWith(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: font_11),
            ),
            Expanded(child: Container())
          ],
        ).paddingOnly(top: margin_10);
      },
      controller: controller.otpTextController,
      focusNode: controller.otpFocusNode,
      length: 4,
      cursor: Padding(
        padding: EdgeInsets.symmetric(vertical: margin_15),
        child: VerticalDivider(
          color: AppColors.appColor,
          thickness: margin_1point2,
        ),
      ),
      pinContentAlignment: Alignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
      ],
      defaultPinTheme: PinTheme(
        width: height_60,
        height: height_63,
        textStyle: textStyleBodyLarge().copyWith(
            color: themeController.isDarkMode.value == true
                ? Colors.white
                : Colors.black),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius_12),
          border: Border.all(
              color: themeController.isDarkMode.value == true
                  ? AppColors.appBorderDarkColor
                  : Colors.grey,
              width: width_1),
          color: themeController.isDarkMode.value == true
              ? Colors.black
              : Colors.white,
        ),
      ),
      showCursor: true,
      isCursorAnimationEnabled: true,
      disabledPinTheme: PinTheme(
        width: height_60,
        height: height_63,
        textStyle: textStyleBodyLarge().copyWith(
            color: themeController.isDarkMode.value == true
                ? Colors.white
                : Colors.black),
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value == true
              ? Colors.black
              : Colors.white,
        ),
      ),
      focusedPinTheme: PinTheme(
        width: height_60,
        height: height_63,
        textStyle: textStyleBodyLarge().copyWith(
            color: themeController.isDarkMode.value == true
                ? Colors.white
                : Colors.black),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius_12),
            border: Border.all(
                color: themeController.isDarkMode.value == true
                    ? AppColors.appBorderDarkColor
                    : Colors.grey,
                width: width_1)),
      ),
      submittedPinTheme: PinTheme(
        width: height_60,
        height: height_63,
        textStyle: textStyleBodyLarge().copyWith(
            color: themeController.isDarkMode.value == true
                ? Colors.white
                : Colors.black),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius_12),
            border: Border.all(
                color: themeController.isDarkMode.value == true
                    ? AppColors.appBorderDarkColor
                    : Colors.cyan,
                width: width_1)),
      ),
      errorTextStyle: textStyleBodyMedium().copyWith(
          color: Colors.red,
          fontWeight: FontWeight.w600,
          fontSize: font_11),
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
    ).paddingOnly(bottom: margin_20, top: margin_20),
  ).paddingSymmetric(horizontal: margin_10);

  Widget _verifyButton() => MaterialButtonWidget(
    onPressed: () {
      controller.verifyOtp();
      // Get.toNamed(AppRoutes.setPasswordRoute);
    },
    textColor: Colors.white,
    buttonText: strContinue,
    buttonBgColor: AppColors.affair,
  ).marginOnly(top: margin_30);

  _timerText() => Text.rich(
    TextSpan(
        text: strResendCodeIn,
        style: textStyleBodyLarge().copyWith(
            color: themeController.isDarkMode.value == true
                ? Colors.white
                : Colors.grey.shade700),
        children: [
          TextSpan(
              text: controller.secondsStr.value,
              // recognizer: TapGestureRecognizer()
              //   ..onTap = () => Get.offAllNamed(AppRoutes.loginRoute),
              style: textStyleTitleSmall().copyWith(
                fontWeight: FontWeight.w600,
                color: themeController.isDarkMode.value == true
                    ? Colors.grey
                    : Colors.black,
                fontSize: font_12,
              )),
        ]),
  );

  Widget _resend() => Align(
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        controller.start.value == 0 ? resendCode() : SizedBox(),
        controller.start.value == 0 ? SizedBox() : _timerText(),
      ],
    ).paddingOnly(top: margin_5),
  );

  Widget resendCode() => Center(
    child: Text.rich(
      TextSpan(
          text: strNotReceivedCode,
          style: textStyleTitleSmall().copyWith(
            color: themeController.isDarkMode.value == true
                ? Colors.white
                : AppColors.greyColor,
          ),
          children: [
            const TextSpan(text: ' '),
            TextSpan(
                text: strResend,
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    controller.start.value = 30;
                    controller.startTimer();
                  },
                style: textStyleTitleSmall().copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.affair,
                    decoration: TextDecoration.underline)),
          ]),
    ),
  );
}
