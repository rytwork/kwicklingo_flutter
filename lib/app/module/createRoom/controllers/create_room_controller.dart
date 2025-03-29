import 'package:flutter/cupertino.dart';

import '../../../export.dart';

class CreateRoomController extends GetxController {

  final List<String> languages = ["EN", "ES", "FR", "DE", "HI", "ZH"];
  final List<String> roomTypes = ["Chat", "Non-Chat"];

  TextEditingController roomNameTextController = TextEditingController();
  FocusNode roomFocusNode = FocusNode();
  bool isPrivate = false;

  String selectedLanguage = "EN";
  String selectedRoomType = "Chat";

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    //TODO Remove this while making build
    super.onReady();
  }

  @override
  void dispose() {
    super.dispose();
  }

}
