import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../export.dart';

class TextFieldWidget extends StatelessWidget {
  final String? hint;
  final Color? fillColor;
  final Color? courserColor;

  final validate;
  final hintStyle;
  final TextStyle? textStyle;
  final EdgeInsets? contentPadding;
  final TextInputType? inputType;
  final TextEditingController? textController;
  final FocusNode? focusNode;
  final Function(String value)? onFieldSubmitted;
  final Function()? onTap;
  final TextInputAction? inputAction;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final decoration;
  final int? minLine;
  final int? maxLength;
  final bool readOnly;
  final bool? obscureText;
  final suffixIconConstraints;
  final Function(String value)? onChange;
  final List<TextInputFormatter>? formatter;

  TextFieldWidget({
    this.hint,
    this.inputType,
    this.textStyle,
    this.textController,
    this.hintStyle,
    this.courserColor,
    this.validate,
    this.onChange,
    this.decoration,
    this.focusNode,
    this.readOnly = false,
    this.onFieldSubmitted,
    this.formatter,
    this.inputAction,
    this.contentPadding,
    this.maxLines,
    this.minLine,
    this.maxLength,
    this.fillColor,
    this.suffixIcon,
    this.prefixIcon,
    this.suffixIconConstraints,
    this.obscureText,
    this.onTap,
  });
  var themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
        readOnly: readOnly,
        onTap: onTap,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: obscureText ?? false,
        controller: textController,
        focusNode: focusNode,
        keyboardType: inputType,
        maxLength: maxLength,
        onChanged: onChange,
        cursorColor: courserColor ?? AppColors.appBorderDarkColor,
        inputFormatters: formatter ??
            [
              FilteringTextInputFormatter(
                  RegExp(
                      '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])'),
                  allow: false)
            ],
        maxLines: maxLines ?? 1,
        minLines: minLine ?? 1,
        obscuringCharacter: "*",
        textInputAction: inputAction,
        onFieldSubmitted: onFieldSubmitted,
        validator: validate,
        style: textStyle ??  textStyleTitleMedium().copyWith(
            fontWeight: FontWeight.w600,
            color: themeController.isDarkMode.value == true
                ? Colors.white
                : Colors.black,
            fontSize: font_13),
        decoration: inputDecoration()));
  }

  inputDecoration() => InputDecoration(
    errorMaxLines: 2,
    hoverColor: AppColors.appBorderDarkColor,
    filled: true,
    isCollapsed: true,
    isDense: true,
    counterText: '',
    contentPadding: contentPadding ??
        EdgeInsets.symmetric(horizontal: margin_15, vertical: margin_15),
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    hintText: hint,
    hintStyle: hintStyle ??
        textStyleBodyMedium().copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
            fontSize: font_14),
    labelText: "",
    floatingLabelBehavior: FloatingLabelBehavior.always,
    fillColor: fillColor ??
        (themeController.isDarkMode.value == true
            ? Colors.black
            : Colors.white),
    border: decoration ??
        OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius_10),
            borderSide: BorderSide(
                color: themeController.isDarkMode.value == true
                    ? AppColors.appBorderDarkColor
                    : Colors.grey.shade400)),
    focusedErrorBorder: decoration ??
        OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius_10),
            borderSide: BorderSide(
                color: themeController.isDarkMode.value == true
                    ? AppColors.appBorderDarkColor
                    : Colors.grey.shade400)),
    errorBorder: decoration ??
        OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius_10),
            borderSide: BorderSide(
                color: themeController.isDarkMode.value == true
                    ? AppColors.appBorderDarkColor
                    : Colors.grey.shade400)),
    focusedBorder: decoration ??
        OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius_10),
            borderSide: BorderSide(
                color: themeController.isDarkMode.value == true
                    ? AppColors.appBorderDarkColor
                    : Colors.grey.shade400)),
    enabledBorder: decoration ??
        OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius_10),
            borderSide: BorderSide(
                color: themeController.isDarkMode.value == true
                    ? AppColors.appBorderDarkColor
                    : Colors.grey.shade400)),
  );
}
