// Controller to manage animation
import 'package:flutter/material.dart';
import '../../../export.dart';

class HomepageController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  var animationValue = 0.0.obs;
  DatabaseManager databaseManager = DatabaseManager();

  @override
  void onInit() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: false);

    animationController.addListener(() {
      animationValue.value = animationController.value;
    });

    super.onInit();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}