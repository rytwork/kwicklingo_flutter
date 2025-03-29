
import '../../../export.dart';

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationController>(
          () => OtpVerificationController(),
    );
  }
}
