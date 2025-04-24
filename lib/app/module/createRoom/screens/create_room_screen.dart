import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import '../../../export.dart';

class CreateRoomScreen extends StatelessWidget {
  final controller = Get.put(CreateRoomController());
  final ThemeController themeController = Get.find<ThemeController>();
  final GlobalKey<FormState> signUpFormGlobalKey = GlobalKey<FormState>();

  CreateRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateRoomController>(
        init: CreateRoomController(),
        builder: (context) {
          return Scaffold(
            backgroundColor:
                themeController.isDarkMode.value ? Colors.white : Colors.grey,
            appBar: AppBar(
              backgroundColor:
                  themeController.isDarkMode.value ? Colors.white : Colors.grey,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: AssetSVGImageWidget(iconsArrow),
              ).paddingOnly(left: margin_10),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextView(
                      text: strCreateARoom,
                      textStyle: textStyleBodyLarge().copyWith(
                          fontSize: font_30, fontWeight: FontWeight.w700),
                    ).paddingOnly(top: margin_20, bottom: margin_16),
                    TextFieldWidget(
                      hint: strEnterName,
                      textController: controller.roomNameTextController,
                      focusNode: controller.roomFocusNode,
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      validate: (value) => FieldChecker.fieldChecker(
                          value: value, message: strName),
                    ).paddingOnly(bottom: margin_16),
                    TextFieldWidget(
                      hint: strTopic,
                      textController: controller.roomNameTextController,
                      focusNode: controller.roomFocusNode,
                      inputType: TextInputType.text,
                      inputAction: TextInputAction.next,
                      validate: (value) => FieldChecker.fieldChecker(
                          value: value, message: strName),
                    ).paddingOnly(bottom: margin_16),
                    _roomTypeCard(),
                    SizedBox(height: height_80),
                    _startRoomButton()
                  ],
                ).paddingOnly(left: margin_15, right: margin_15),
              ),
            ),
          );
        });
  }

  Widget _startRoomButton() => MaterialButtonWidget(
        buttonBgColor: AppColors.affair,
        onPressed: () {
          // controller.signUp();
        },
        buttonText: strStartVoiceRoom,
        buttonTextStyle: textStyleBodyMedium().copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: font_18),
      );

  _roomTypeCard() => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Language:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: controller.selectedLanguage,
                    icon: Icon(Icons.keyboard_arrow_right),
                    items: controller.languages.map((String lang) {
                      return DropdownMenuItem<String>(
                        value: lang,
                        child: Text(lang),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedLanguage = value ?? "";
                      controller.update();
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Room Type Dropdown
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Room Type:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: controller.selectedRoomType,
                    icon: Icon(Icons.keyboard_arrow_right),
                    items: controller.roomTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedRoomType = value ?? "";
                      controller.update();
                    },
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Toggle for Private/Public
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Room Privacy:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  FlutterSwitch(
                    width: 80,
                    height: 30,
                    value: controller.isPrivate,
                    borderRadius: 20,
                    activeColor: Colors.green,
                    inactiveColor: Colors.red,
                    activeText: "Private",
                    inactiveText: "Public",
                    showOnOff: true,
                    onToggle: (val) {
                      controller.isPrivate = val ?? false;
                      controller.update();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
