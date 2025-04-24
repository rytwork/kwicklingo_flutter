import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../export.dart';

class VideoCallController extends GetxController {
  late final RtcEngine engine;
  final TextEditingController channelController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final FocusNode channelFocusNode = FocusNode();
  ScrollController scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final int dotCount = 7;
  List<Color> dotColors = [Colors.yellow];
  Set<int> remoteUsers = {};
  bool isJoined = false;
  bool switchCamera = true;
  bool openCamera = true;
  bool muteCamera = false;
  bool isMuted = false;
  bool muteAllRemoteVideo = false;
  String channel = "";
  final String appId = "78e6f90660864bdb959afaaf1023e313";
  var token = "";
  var myUId = "";
  bool isRemoteVideoMuted = false;
  bool isRemoteAudioMuted = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    dotColors = List.generate(dotCount, (index) => Colors.yellow);

    await _requestPermissions();
    await _initializeAgoraVideoSDK();
    await setupLocalVideo();
    setupEventHandlers();
    _startAnimation();
    await listenForUpdates(); // Only call joinChannel inside this
  }

  Future<void> _requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  Future<void> _initializeAgoraVideoSDK() async {
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
  }

  Future<void> setupLocalVideo() async {
    await engine.enableVideo();
    await engine.startPreview();
  }

  void setupEventHandlers() {
    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          isJoined = true;
          update();
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) async {
          debugPrint("Remote user $uid joined");
          isRemoteVideoMuted = false;
          await deleteConnection();
          remoteUsers.add(uid);
          update();
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) async {
          debugPrint("Remote user $remoteUid left");
          remoteUsers.remove(remoteUid);
          await deleteConnection();
          await deleteChannel(channel);
          Get.back();
          update();
        },
        onRemoteVideoStateChanged: (
          RtcConnection connection,
          int remoteUid,
          RemoteVideoState state,
          RemoteVideoStateReason reason,
          int elapsed,
        ) {
          debugPrint("Remote video state changed for $remoteUid: $state");

          if (state == RemoteVideoState.remoteVideoStateStopped ||
              state == RemoteVideoState.remoteVideoStateFrozen) {
            isRemoteVideoMuted = true;
          } else if (state == RemoteVideoState.remoteVideoStateDecoding ||
              state == RemoteVideoState.remoteVideoStateStarting) {
            isRemoteVideoMuted = false;
          }
          update();
        },
        onUserMuteAudio: (RtcConnection connection, int remoteUid, bool muted) {
          debugPrint("Remote user $remoteUid audio muted: $muted");
          isRemoteAudioMuted = muted;
          update(); // For GetX, or setState otherwise
        },
        onError: (ErrorCodeType code, String message) {
          debugPrint("Agora SDK error: $code, $message");
        },
      ),
    );
  }

  Future<void> listenForUpdates() async {
    FirebaseFirestore.instance
        .collection("connections")
        .doc("connected-users")
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null) {
          for (var entry in data.entries) {
            var channelName = entry.key;
            var details = entry.value;
            User? user = _auth.currentUser;
            var myUid = user?.uid ?? "";
            if (details['uid1'] == myUid || details['uid2'] == myUid) {
              token = details['token'];
              channel = channelName;
              print("Token received: $token");
              print("Channel name received: $channel");
              if (token.isNotEmpty && channel.isNotEmpty && !isJoined) {
                await joinChannel();
              }
            }
          }
        } else {
          print("data is null");
        }
      }
    });
  }

  Future<void> joinChannel() async {
    print("Attempting to join channel: $channel");
    print("Using token: $token");

    await engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(
        autoSubscribeVideo: true,
        autoSubscribeAudio: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        audienceLatencyLevel:
            AudienceLatencyLevelType.audienceLatencyLevelUltraLowLatency,
      ),
      uid: 0,
    );
  }

  Future<void> leaveChannel() async {
    await deleteConnection();
    await engine.leaveChannel();
    openCamera = true;
    muteCamera = false;
    muteAllRemoteVideo = false;
    isJoined = false;
    await deleteChannel(channel);
    update();
    Get.back();
  }

  Future<void> switchUserCamera() async {
    await engine.switchCamera();
    switchCamera = !switchCamera;
    update();
  }

  void toggleMute() {
    isMuted = !isMuted;
    engine.muteLocalAudioStream(isMuted);
    update();
  }

  Future<void> toggleCamera() async {
    await engine.enableLocalVideo(!openCamera);
    openCamera = !openCamera;
    update();
  }

  Future<void> toggleMuteCamera() async {
    muteCamera = !muteCamera;
    update();
    await engine.muteLocalVideoStream(!muteCamera);
  }

  Future<void> deleteConnection() async {
    User? user = _auth.currentUser;
    var myUid = user?.uid;
    if (myUid == null) {
      print("No user is logged in");
      return;
    }
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("connections")
          .doc("connected-users")
          .get();
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data is Map<String, dynamic>) {
          for (var entry in data.entries) {
            var channelName = entry.key;
            var details = entry.value;
            if (details['uid1'] == myUid || details['uid2'] == myUid) {
              print("Deleting channel: $channelName");
              await FirebaseFirestore.instance
                  .collection("connections")
                  .doc("connected-users")
                  .update({
                channelName: FieldValue.delete(),
              });
              print("Connection deleted for channel: $channelName");
            }
          }
        } else {
          print("Document data is null");
        }
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error deleting connection: $e");
    }
  }

  void _startAnimation() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateColors();
    });
  }

  void _updateColors() {
    for (int i = 0; i < dotCount; i++) {
      dotColors[i] = _getRandomColor();
    }
    update();
  }

  Color _getRandomColor() {
    return Color((0xFF000000 +
                (0x00FFFFFF * (DateTime.now().millisecond % 1000) / 1000))
            .toInt())
        .withOpacity(1.0);
  }

  void sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    print("user_id: ${user?.uid}");
    myUId = user?.uid ?? "";
    var message = messageController.text.trim();
    if (user != null && message.isNotEmpty) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          final data = doc.data();
          String userName = data?['name'] ?? 'No name';
          await FirebaseFirestore.instance
              .collection('channels')
              .doc((channel == "") ? "unknown" : channel)
              .collection('messages')
              .add({
            'text': message,
            'createdAt': Timestamp.now(),
            'userId': user.uid,
            'userName': userName,
          });

          messageController.clear();
          update();
          scrollToBottom();
        } else {
          print("No user data found for UID: ${user.uid}");
        }
      } catch (e) {
        print("Error sending message: $e");
      }
    }
    update();
  }

  Future<void> deleteChannel(String channelId) async {
    final channelRef =
        FirebaseFirestore.instance.collection('channels').doc(channelId);
    final messagesRef = channelRef.collection('messages');

    try {
      // Fetch and delete all messages
      final messagesSnapshot = await messagesRef.get();
      for (final doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete the channel document
      await channelRef.delete();

      print('Channel and its messages deleted successfully.');
    } catch (e) {
      print('Error deleting channel: $e');
    }
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 10), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.snackbar("KwickLingo", "Logged out successfully",
          backgroundColor: Colors.white12);
      Get.offAllNamed(AppRoutes.splashRoute);
    } catch (e) {
      Get.snackbar("KwickLingo", "Error: ${e.toString()}");
    }
  }

  Color getRandomColor() {
    final random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(200),
      random.nextInt(200),
      random.nextInt(200),
    );
  }

  String getRandomChar() {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return alphabet[Random().nextInt(alphabet.length)];
  }

  final List<Message> messages = List.generate(
    20,
    (index) => Message(
      text: 'Message number $index',
      userName: 'User $index',
    ),
  );
}

class Message {
  final String text;
  final String userName;
  Message({required this.text, required this.userName});
}
