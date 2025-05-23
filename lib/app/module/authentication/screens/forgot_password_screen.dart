import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../export.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final controller = Get.put(ForgotPasswordController());
  final ThemeController themeController = Get.find<ThemeController>();
  final GlobalKey<FormState> forgotPasswordFormGlobalKey =
      GlobalKey<FormState>();

  ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: AssetSVGImageWidget(iconsArrow),
          ).paddingOnly(left: margin_6),
        ),
        body: GetBuilder<ForgotPasswordController>(
            init: ForgotPasswordController(),
            builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height_20),
                  // AuthenticationScreenHeading(
                  //   title: strForgotPassword,
                  // ),
                  TextView(
                    text: strForgotPassword,
                    textAlign: TextAlign.center,
                    textStyle: textStyleBodyLarge().copyWith(
                      fontSize: font_30,
                      fontWeight: FontWeight.w700,
                    ),
                  ).paddingOnly(bottom: margin_10),
                  TextView(
                          text: strForgotPasswordDis,
                          maxLines: 4,
                          textAlign: TextAlign.start,
                          textStyle: textStyleBodyLarge()
                              .copyWith(color: AppColors.paleSky))
                      .paddingOnly(bottom: margin_15),
                  _form(),
                  _sendButton(),
                  Spacer(),
                  Center(child: login())
                ],
              ).paddingSymmetric(horizontal: margin_20);
            }),
      ),
    );
  }

  _form() => Form(
        key: forgotPasswordFormGlobalKey,
        child: _emailTextField(),
      ).paddingOnly(bottom: margin_15);

  _emailTextField() => TextFieldWidget(
        hint: strEnterYrEmail,
        textController: controller.emailTextController,
        focusNode: controller.emailFocusNode,
        inputType: TextInputType.emailAddress,
        // maxLength: 15,
        validate: (value) => EmailValidator.validateEmail(value),
        inputAction: TextInputAction.next,
      ).paddingSymmetric(
        vertical: margin_15,
      );

  Widget _sendButton() => MaterialButtonWidget(
        buttonBgColor: AppColors.affair,
        onPressed: () {
          if (forgotPasswordFormGlobalKey.currentState!.validate()) {
            controller.resetPassword();
          }
        },
        buttonText: strResetPassword,
        buttonTextStyle: textStyleBodyLarge().copyWith(color: Colors.white),
      ).paddingOnly(top: margin_10);

  Widget login() => Text.rich(
        TextSpan(
            text: strRememberPassword,
            style: textStyleTitleSmall().copyWith(
              color: themeController.isDarkMode.value == true
                  ? Colors.white
                  : AppColors.greyColor,
            ),
            children: [
              const TextSpan(text: ' '),
              TextSpan(
                  text: strLogin,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.toNamed(AppRoutes.loginRoute),
                  style: textStyleTitleSmall().copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.affair,
                      decoration: TextDecoration.underline)),
            ]),
      ).paddingOnly(bottom: margin_24);
}
