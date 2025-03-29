import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../export.dart';

class SingInScreen extends StatelessWidget {
  final controller = Get.put(SignInController());
  final themeController = Get.put(ThemeController());
  final GlobalKey<FormState> loginFormGlobalKey = GlobalKey<FormState>();

  SingInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignInController>(
      init: SignInController(),
      builder: (controller) {
        return IgnorePointer(
          ignoring: !controller.isLoggedIn,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: InkWell(
                onTap: (){
                  Get.back();
                },
                child: AssetSVGImageWidget(Assets.iconsArrow),
              ).paddingOnly(left: margin_6),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                height: Get.height * 0.87,
                width: Get.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    _loginText(),
                    _form(),
                    forgetPassword(),
                    _loginButton(),
                    Spacer(),
                    _signup(),
                  ],
                ).paddingAll(margin_20),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _loginText() => Align(
    alignment: Alignment.centerLeft,
    child: TextView(
      text: strLoginTitle,
      maxLines: 2,
      textStyle: textStyleHeadlineLarge().copyWith(
        fontSize: 30,
        color: themeController.isDarkMode.value ? Colors.white : Colors.black,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  Widget _form() => Form(
    key: loginFormGlobalKey,
    child: Column(
      children: [
        _emailTextField(),
        _passwordTextField(),
      ],
    ).paddingOnly(top: 20),
  );

  Widget _emailTextField() => TextFieldWidget(
    hint: strEnterEmail,
    textController: controller.emailTextController,
    focusNode: controller.emailFocusNode,
    inputType: TextInputType.emailAddress,
    validate: (value) => EmailValidator.validateEmail(value),
    inputAction: TextInputAction.next,
  );

  Widget _passwordTextField() => TextFieldWidget(
    hint: strEnterPassword,
    textController: controller.passwordTextController,
    focusNode: controller.passwordFocusNode,
    inputType: TextInputType.visiblePassword,
    obscureText: controller.viewPassword.value,
    validate: (value) => PasswordFormValidator.validatePassword(value),
    suffixIcon: InkWell(
      onTap: () {
        controller.viewPassword.value = !controller.viewPassword.value;
        controller.update();
      },
      child: AssetSVGImageWidget(
        controller.viewPassword.value ? iconsFluentEye20Filledeye : iconsFluentEyeHideRegularIcon,
        color: AppColors.themeButtonColor.withAlpha(150),
      ).paddingSymmetric(vertical: 15, horizontal: 10),
    ),
    inputAction: TextInputAction.next,
  ).paddingOnly(top: 20);

  Widget _loginButton() => MaterialButtonWidget(
    buttonBgColor: AppColors.affair,
    textColor: Colors.white,
    onPressed: () {
      // controller.signIn();
      Get.toNamed(AppRoutes.videoCallScreen);
    },
    buttonText: strLogin,
  );

  Widget forgetPassword() => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Spacer(),
      InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.forgotPassword);
        },
        child: TextView(
          text: strForgotPassword,
          textStyle: textStyleBodyLarge().copyWith(
            color: AppColors.affair,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      )
    ],
  ).paddingOnly(top: 8, bottom: 30);

  Widget _signup() => Text.rich(
    TextSpan(
      text: strDntHaveAcount,
      style: textStyleTitleSmall().copyWith(
        color: themeController.isDarkMode.value ? Colors.white : AppColors.greyColor,
      ),
      children: [
        const TextSpan(text: ' '),
        TextSpan(
          text: strRegisterNow,
          recognizer: TapGestureRecognizer()
            ..onTap = () => Get.toNamed(AppRoutes.signupRoute),
          style: textStyleTitleSmall().copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.affair,
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    ),
  ).paddingOnly(bottom: 24);
}
