import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../export.dart';

class UploadProfileScreen extends StatelessWidget {
  final controller = Get.put(UploadProfileController());
  final themeController = Get.put(ThemeController());
  final GlobalKey<FormState> otpVerifyFormGlobalKey = GlobalKey<FormState>();

  UploadProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UploadProfileController>(
        init: UploadProfileController(),
        builder: (controller) {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                GestureDetector(
                  onTap: (){
                    showImageSourceDialog(context);
                  },
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage:
                    controller.imageFile != null ? FileImage(controller.imageFile!) : null,
                    child: controller.imageFile == null
                        ? Icon(Icons.add_a_photo, size: 40, color: Colors.white)
                        : null,
                  ),
                ),
                SizedBox(height: 100),
                _verifyButton(),
              ],
            ).paddingSymmetric(horizontal: margin_20),
          );
        });
  }

  showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          Container(
            padding: const EdgeInsets.all(10),
            height: 150,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Pick from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
    );
  }
  
  
  Widget _verifyButton() => MaterialButtonWidget(
    onPressed: () async {
      if (controller.imageFile != null) {
        String? imageUrl = await controller.uploadImageToFirebase(controller.imageFile!);
        print("Uploaded Image URL: $imageUrl");
      }
      // Get.toNamed(AppRoutes.setPasswordRoute);
    },
    textColor: Colors.white,
    buttonText: strUpload,
    buttonBgColor: AppColors.affair,
  ).marginOnly(top: margin_30);

}
