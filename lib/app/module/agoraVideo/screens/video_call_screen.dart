import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../../../export.dart';

class VideoCallScreen extends StatelessWidget {
  final controller = Get.put(VideoCallController());

  VideoCallScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoCallController>(
      init: VideoCallController(),
      builder: (controller) {
        return Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: height_80,
                child: Row(
                  children: [
                    SizedBox(
                      width: width_20,
                    ),
                    InkWell(
                      child: Container(
                        height: height_30,
                        width: height_100,
                        decoration: BoxDecoration(
                          color: AppColors.affair,
                          borderRadius: BorderRadius.circular(radius_5), // Wrap in BorderRadius.circular
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AssetImageWidget(iconsGender,color: Colors.white,imageHeight: height_20,),
                            SizedBox(width: width_5),
                            TextView(text: strAll,textStyle: textStyleBodyLarge().copyWith(
                              color: Colors.white,
                              fontSize: font_12,
                              fontWeight: FontWeight.w500
                            ),)
                          ],
                        ),
                      ),
                    ).paddingOnly(top: margin_10),
                    SizedBox(width: height_10),
                    InkWell(
                      child: Container(
                        height: height_30,
                        width: height_100,
                        decoration: BoxDecoration(
                          color: AppColors.affair,
                          borderRadius: BorderRadius.circular(radius_5), // Wrap in BorderRadius.circular
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AssetImageWidget(iconsGlobe,color: Colors.white,imageHeight: height_20,),
                            SizedBox(width: width_5),
                            TextView(text: strGlobal,textStyle: textStyleBodyLarge().copyWith(
                                color: Colors.white,
                                fontSize: font_12,
                                fontWeight: FontWeight.w500
                            ),)
                          ],
                        ),
                      ),
                    ).paddingOnly(top: margin_10),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(100.0, 100.0, 0.0, 0.0),
                          items: [
                            PopupMenuItem(
                              value: 'logout',
                              child: TextView(text: 'Logout',textStyle: textStyleBodyLarge().copyWith(
                                fontSize: font_13,
                                fontWeight: FontWeight.w700
                              ),),
                            ),
                          ],
                        ).then((value) {
                          if (value == 'logout') {
                            controller.logout();
                          }
                        });
                      },
                      child: AssetImageWidget(iconsAccount,color: Colors.black,imageHeight: height_20,),
                    ).paddingOnly(top: margin_12,right: margin_20),
                  ],
                ),
              ),
              // Remote video on top half
              Expanded(
                child: controller.remoteUsers.isNotEmpty
                    ? remoteVideo()
                    : Center(
                        child: Container(
                        color: AppColors.purpleAlabaster,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AssetImageWidget(
                                iconsKwickLingoLogo,
                                imageWidth: width_150,
                              ),
                              TextView(
                                text: strFindAvailable,
                                textStyle: textStyleBodyLarge()
                                    .copyWith(fontSize: font_12),
                              ),
                              SizedBox(
                                height: height_5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    List.generate(controller.dotCount, (index) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      // Safeguard to prevent index error
                                      color: index < controller.dotColors.length
                                          ? controller.dotColors[index]
                                          : Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }),
                              )
                            ]),
                      )),
              ),
              // Local video on bottom half
              Expanded(
                child: Stack(
                  children: [
                    // Local video view
                    controller.isJoined
                        ? localVideo()
                        : const Center(child: CircularProgressIndicator()),

                    // Chat view overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: Get.height/2.2,
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: controller.scrollController,
                                itemCount: controller.messages.length,
                                reverse: true,
                                itemBuilder: (context, index) {
                                  return TextView(text: controller.messages[index]);
                                },
                              ),
                            ),
                            // Input field for sending messages
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: controller.messageController,
                                    decoration: const InputDecoration(
                                      hintText: "Type a message...",
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.send, color: Colors.grey),
                                  onPressed: controller.sendMessage,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )

            ],
          ),
          // floatingActionButton: FloatingActionButton(
          //   backgroundColor: Colors.red,
          //   onPressed: controller.isJoined
          //       ? controller.leaveChannel
          //       : controller.joinChannel,
          //   child: Icon(
          //     controller.isJoined ? Icons.call_end : Icons.call,
          //     color: Colors.white,
          //   ),
          // ),
        );
      },
    );
  }

  // Renders the remote user's video view
  Widget remoteVideo() {
    if (controller.remoteUsers.isNotEmpty) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: controller.engine,
          canvas: VideoCanvas(uid: controller.remoteUsers.first),
          connection: RtcConnection(channelId: controller.channel),
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Waiting for remote user to join...',
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  // Displays the local user's video view
  Widget localVideo() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: controller.engine,
        canvas: const VideoCanvas(
          uid: 0,
          renderMode: RenderModeType.renderModeHidden,
        ),
      ),
    );
  }
}
