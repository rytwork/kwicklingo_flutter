
import '../export.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ThemeController());
    SplashBinding().dependencies();
  }
}
