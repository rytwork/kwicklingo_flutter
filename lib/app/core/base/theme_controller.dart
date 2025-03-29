import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../main.dart';
import '../../export.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = isDarkModeTheme;

  @override
  void onInit() {
    ever(isDarkModeTheme, (isDark) {
      isDarkMode.value=isDark;
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:isDarkMode.value==true? Brightness.light:Brightness.dark));
    });
    super.onInit();
  }
}