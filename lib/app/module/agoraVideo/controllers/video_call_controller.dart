import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallController extends GetxController {
  late final RtcEngine engine;
  final TextEditingController channelController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final FocusNode channelFocusNode = FocusNode();
  ScrollController scrollController = ScrollController();

  final int dotCount = 7;
  List<Color> dotColors = [Colors.yellow];
  List<String> messages = [];

  Set<int> remoteUsers = {};
  bool isJoined = false;
  bool switchCamera = true;
  bool openCamera = true;
  bool muteCamera = false;
  bool muteAllRemoteVideo = false;
  String channel = "test_channel";

  final String appId = "78e6f90660864bdb959afaaf1023e313";
  final String token = "00678e6f90660864bdb959afaaf1023e313IADH9Nbi9dErHnTpmerOcUCfRIgfolMV3oBTK+EP4TnDp49auH4AAAAAIgCs7VDNYp/dZwQAAQDyW9xnAgDyW9xnAwDyW9xnBADyW9xn";

  @override
  Future<void> onInit() async {
    super.onInit();
    dotColors = List.generate(dotCount, (index) => Colors.yellow);
    await _requestPermissions();
    await _initializeAgoraVideoSDK();

    await setupLocalVideo();
    setupEventHandlers();
    _startAnimation();
    await joinChannel();

  }


  void _startAnimation() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateColors();
      debugPrint("Dot colors updated: ${dotColors.length}");
    });
  }


  void _updateColors() {
    for (int i = 0; i < dotCount; i++) {
      dotColors[i] = _getRandomColor();
    }
    update(); // To rebuild UI with new colors
  }

  Color _getRandomColor() {
    return Color((0xFF000000 + (0x00FFFFFF * (DateTime.now().millisecond % 1000) / 1000)).toInt())
        .withOpacity(1.0);
  }

  Future<void> _requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }


  // Set up the Agora RTC engine instance
  Future<void> _initializeAgoraVideoSDK() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
  }

// Register an event handler for Agora RTC
  void setupEventHandlers() {
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          isJoined = true;
          update();
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          debugPrint("Remote user $uid joined");
          remoteUsers.add(uid);
          update();
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("Remote user $remoteUid left");
          remoteUsers.add(remoteUid);
          update();
        },
      ),
    );
  }

  Future<void> setupLocalVideo() async {
    await engine.enableVideo();
    await engine.startPreview();
  }

  // Join a channel
  Future<void> joinChannel() async {
    await engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          audienceLatencyLevel: AudienceLatencyLevelType.audienceLatencyLevelUltraLowLatency
      ),
      uid: 0,
    );
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
    openCamera = true;
    muteCamera = false;
    muteAllRemoteVideo = false;
    isJoined = false;
    update();
    Get.back();
  }

  Future<void> switchUserCamera() async {
    await engine.switchCamera();
    switchCamera = !switchCamera;
    update();
  }

  Future<void> toggleCamera() async {
    await engine.enableLocalVideo(!openCamera);
    openCamera = !openCamera;
    update();
  }

  Future<void> toggleMuteCamera() async {
    await engine.muteLocalVideoStream(!muteCamera);
    muteCamera = !muteCamera;
    update();
  }


  void sendMessage(){
    messages.insert(0, messageController.text);
    messageController.text = "";
    update();
    scrollToBottom();
  }


  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 10), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }
}