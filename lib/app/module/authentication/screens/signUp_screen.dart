import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../../export.dart';

class SignUpScreen extends StatelessWidget {
  final controller = Get.put(SignUpController());
  final ThemeController themeController = Get.find<ThemeController>();
  final GlobalKey<FormState> signUpFormGlobalKey = GlobalKey<FormState>();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
        init: SignUpController(),
        builder: (controller) {
          return IgnorePointer(
            ignoring: controller.isIgnoreInteraction,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: AssetSVGImageWidget(Assets.iconsArrow),
                ).paddingOnly(left: margin_6),
              ),
              body: SingleChildScrollView(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: height_10),
                          TextView(
                            text: strSignup,
                            textStyle: textStyleBodyLarge().copyWith(
                                fontWeight: FontWeight.w700, fontSize: font_28),
                          ),
                          SizedBox(height: height_12),
                          _signUptTitleText(),
                          _form(context),
                          _signupButton()
                        ],
                      ).paddingSymmetric(horizontal: margin_20),
                      SizedBox(height: height_20),
                      _signIn()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _signUptTitleText() => Text(
        strSignupTitle,
        style: textStyleHeadlineLarge().copyWith(
            fontSize: font_14,
            color: themeController.isDarkMode == true
                ? Colors.white
                : Colors.black,
            fontWeight: FontWeight.w400),
      ).paddingOnly(bottom: margin_8);

  _form(BuildContext context) => Form(
        key: signUpFormGlobalKey,
        child: Column(
          children: [
            _nameTextField(),
            _userNameTextField(),
            _phoneNumberField(context),
            _emailTextField(),
            _passwordTextField(),
            _cnfPasswordTextField()
          ],
        ).paddingOnly(top: margin_20, bottom: margin_10),
      );

  _nameTextField() => TextFieldWidget(
        hint: strEnterName,
        textController: controller.nameTextController,
        focusNode: controller.nameFocusNode,
        inputType: TextInputType.text,
        inputAction: TextInputAction.next,
        validate: (value) =>
            FieldChecker.fieldChecker(value: value, message: strName),
      ).paddingOnly(bottom: margin_15);

  _userNameTextField() => TextFieldWidget(
        hint: strEnterUserName,
        textController: controller.useNameTextController,
        focusNode: controller.userNameFocusNode,
        inputType: TextInputType.text,
        inputAction: TextInputAction.next,
        validate: (value) =>
            FieldChecker.fieldChecker(value: value, message: strName),
      ).paddingOnly(bottom: margin_15);

  _phoneNumberField(context) => PhoneFormField(
        focusNode: controller.phoneFieldFocusNode,
        controller: controller.phoneFieldController,
        isCountryButtonPersistent: controller.isCountryButtonPersistant,
        autofocus: false,
        autofillHints: const [AutofillHints.telephoneNumber],
        countrySelectorNavigator: controller.selectorNavigator,
        decoration: InputDecoration(
          errorMaxLines: 2,
          hoverColor: AppColors.appBorderDarkColor,
          filled: true,
          isCollapsed: true,
          isDense: true,
          counterText: '',
          counterStyle: textStyleBodyMedium().copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: font_14),
          contentPadding: EdgeInsets.symmetric(horizontal: margin_15, vertical: margin_15),
          labelText: "",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          fillColor: (themeController.isDarkMode.value == true
                  ? Colors.black
                  : Colors.white),
          border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius_10),
                  borderSide: BorderSide(
                      color: themeController.isDarkMode.value == true
                          ? AppColors.appBorderDarkColor
                          : Colors.grey.shade400)),
          hintText: strPhoneNumber,
          hintStyle: textStyleBodyMedium().copyWith(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: font_14),
          focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius_10),
                  borderSide: BorderSide(
                      color: themeController.isDarkMode.value == true
                          ? AppColors.appBorderDarkColor
                          : Colors.grey.shade400)),
          errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius_10),
                  borderSide: BorderSide(
                      color: themeController.isDarkMode.value == true
                          ? AppColors.appBorderDarkColor
                          : Colors.grey.shade400)),
          focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius_10),
                  borderSide: BorderSide(
                      color: themeController.isDarkMode.value == true
                          ? AppColors.appBorderDarkColor
                          : Colors.grey.shade400)),
          enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(radius_10),
                  borderSide: BorderSide(
                      color: themeController.isDarkMode.value == true
                          ? AppColors.appBorderDarkColor
                          : Colors.grey.shade400)),
        ),
        enabled: true,
        countryButtonStyle: const CountryButtonStyle(
          showFlag: true,
          showIsoCode: false,
          showDialCode: true,
          showDropdownIcon: true,
        ),
        validator: controller.getValidator(context),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: Theme.of(context).colorScheme.primary,
        // ignore: avoid_print
        onSaved: (p) => print('saved $p'),
        // ignore: avoid_print
        onChanged: (p) => print('changed $p'),
      ).paddingOnly(bottom: margin_15);

  _emailTextField() => TextFieldWidget(
        hint: strEnterEmail,
        textController: controller.emailTextController,
        focusNode: controller.emailFocusNode,
        inputType: TextInputType.emailAddress,
        inputAction: TextInputAction.next,
        validate: (value) => EmailValidator.validateEmail(value),
      ).paddingOnly(bottom: margin_15);

  _passwordTextField() => TextFieldWidget(
        hint: strEnterPassword,
        textController: controller.passwordTextController,
        focusNode: controller.passwordFocusNode,
        inputType: TextInputType.visiblePassword,
        obscureText: controller.viewPassword.value,
        formatter: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        validate: (value) => PasswordFormValidator.validatePassword(value),
        onFieldSubmitted: (v) {
          FocusScope.of(Get.overlayContext!)
              .requestFocus(controller.confirmPasswordFocusNode);
        },
        suffixIcon: InkWell(
          onTap: () {
            controller.viewPassword.value = !controller.viewPassword.value;
            controller.update();
          },
          child: AssetSVGImageWidget(
            controller.viewPassword.value
                ? iconsFluentEye20Filledeye
                : iconsFluentEyeHideRegularIcon,
            color: AppColors.themeButtonColor.withAlpha(150),
          ).paddingSymmetric(vertical: margin_15, horizontal: margin_10),
        ),
        inputAction: TextInputAction.done,
      ).paddingOnly(bottom: margin_15);

  _cnfPasswordTextField() => TextFieldWidget(
        hint: strEnterCnfPassword,
        textController: controller.confirmPasswordTextController,
        focusNode: controller.confirmPasswordFocusNode,
        inputType: TextInputType.visiblePassword,
        obscureText: controller.confirmViewPassword.value,
        formatter: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        validate: (value) => PasswordFormValidator.validatePassword(value),
        onFieldSubmitted: (v) {
          FocusScope.of(Get.overlayContext!)
              .requestFocus(controller.confirmPasswordFocusNode);
        },
        suffixIcon: InkWell(
          onTap: () {
            controller.confirmViewPassword.value =
                !controller.confirmViewPassword.value;
            controller.update();
          },
          child: AssetSVGImageWidget(
            controller.confirmViewPassword.value
                ? iconsFluentEye20Filledeye
                : iconsFluentEyeHideRegularIcon,
            color: AppColors.themeButtonColor.withAlpha(150),
          ).paddingSymmetric(vertical: margin_15, horizontal: margin_10),
        ),
        inputAction: TextInputAction.done,
      ).paddingOnly(bottom: margin_15);

  Widget _signupButton() => MaterialButtonWidget(
        buttonBgColor: AppColors.affair,
        onPressed: () {
          if (signUpFormGlobalKey.currentState!.validate()) {
            print(controller.phoneFieldController.value);
            controller.signUp();
          }
        },
        buttonText: strRegister,
        buttonTextStyle: textStyleBodyMedium().copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: font_18),
      );

  Widget _signIn() => Text.rich(
        TextSpan(
            text: strAlreadyAccount,
            style: textStyleTitleSmall().copyWith(
              color: themeController.isDarkMode.value == true
                  ? Colors.white
                  : AppColors.greyColor,
            ),
            children: [
              TextSpan(
                  text: strLoginNow,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.toNamed(AppRoutes.loginRoute),
                  style: textStyleTitleSmall().copyWith(
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      color: AppColors.affair)),
            ]),
      ).paddingOnly(bottom: margin_12);

  Widget socialSignIn() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
              onTap: () {
                // controller.signInWithFacebook();
              },
              child: AssetSVGImageWidget(iconsFacebook)),
          Spacer(),
          InkWell(
              onTap: () {
                // controller.signInWithGoogle();
              },
              child: AssetSVGImageWidget(iconsGoogle)),
          Spacer(),
          InkWell(onTap: () {}, child: AssetSVGImageWidget(iconsApple)),
        ],
      ).paddingOnly(top: margin_30);
}
