import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../export.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
        init: SplashController(),
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AssetImageWidget(
                    radiusAll: height_160/2,
                    iconsKwicklingo,
                    imageHeight: height_160,
                    imageWidth: height_160,
                    imageFitType: BoxFit.fill,
                  ).paddingOnly(bottom: margin_10).animate().slideY(delay: Duration(milliseconds: 100)),

                ],
              ),
            ),
          );
        });
  }
}
