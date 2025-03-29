import '../../../export.dart';

class CreateRoomBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateRoomController>(
          () => CreateRoomController(),
    );
  }
}
