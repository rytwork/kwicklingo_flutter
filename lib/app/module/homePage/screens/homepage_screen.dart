import 'package:flutter/material.dart';
import 'package:KwickLingo/app/module/homePage/widget/custom_drawer.dart';
import '../../../export.dart';

class HomepageScreen extends StatelessWidget {
  final HomepageController controller = Get.put(HomepageController());

  HomepageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(
          child: TextView(
            text: "KwickLingo",
            textStyle: textStyleBodyLarge().copyWith(
              fontSize: font_14,
              fontWeight: FontWeight.w700,
              color: AppColors.affair,
            ),
          ).paddingOnly(top: margin_6, right: margin_30),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: controller.openDrawer,
        ),
      ),

      // Wrap drawer in Obx
      drawer: Obx(() {
        final data = controller.userData.value ?? {};
        return ProfileDrawer(
          profileImageUrl: data["profilePicUrl"] ?? "",
          name: data["name"] ?? "",
          contactNumber: "+${data["countryCode"] ?? ""}${data["phoneNumber"] ?? ""}",
          email: data["email"] ?? "",
          onLogout: controller.logoutUser,
        );
      }),

     body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: height_100),
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Obx(() => CustomPaint(
                painter:
                CircleWavePainter(controller.animationValue.value),
                child: const SizedBox(
                  width: 350,
                  height: 350,
                ),
              )),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage(iconsKwicklingo), // Add your image
                    fit: BoxFit.cover,
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ],
          ),
        ),
        Spacer(),
        MaterialButton(
          color: AppColors.affair,
          onPressed: () async {
            var user = await controller.databaseManager.getCurrentUser();
            print("user id : ${user?.uid}");
            controller.databaseManager.addToWaitingUsers(user?.uid ?? "");
            Get.toNamed(AppRoutes.videoCallScreen);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextView(
                text: strLetsConnect,
                textStyle: textStyleBodyLarge().copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: font_14),
              ),
              SizedBox(
                width: width_10,
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: font_14,
              )
            ],
          ),
        ).paddingAll(margin_20),
        SizedBox(height: height_20),
      ],
    ),
    );
  }
}


// Custom Painter for circle waves
class CircleWavePainter extends CustomPainter {
  final double progress;

  CircleWavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue.withOpacity(1 - progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    double maxRadius = size.width / 2;
    double radius = maxRadius * progress;

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(
        size.center(Offset.zero),
        radius - (i * 20),
        paint
          ..color = Colors.blue.withOpacity((1 - progress) * (1 - (i * 0.3))),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
