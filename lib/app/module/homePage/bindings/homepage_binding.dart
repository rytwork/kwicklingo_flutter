import '../../../export.dart';

class HomepageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomepageController>(
          () => HomepageController(),
    );
  }
}
