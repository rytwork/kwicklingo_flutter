import '../../../export.dart';

class UploadProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UploadProfileController>(
          () => UploadProfileController(),
    );
  }
}
