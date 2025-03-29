
import '../../../export.dart';

class VideoCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VideoCallController>(
          () => VideoCallController(),
    );
  }
}
