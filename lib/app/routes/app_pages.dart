import 'package:kwicklingo/app/module/authentication/bindings/otp_verification_binding.dart';
import 'package:kwicklingo/app/module/homePage/bindings/homepage_binding.dart';
import 'package:kwicklingo/app/module/homePage/screens/homepage_screen.dart';
import 'package:kwicklingo/app/module/uploadProfile/bindings/upload_profile_binding.dart';
import 'package:kwicklingo/app/module/uploadProfile/screens/upload_profile_screen.dart';

import '../export.dart';

class AppPages {
  static const INITIAL = AppRoutes.splashRoute;

  static final routes = [
    GetPage(
      name: AppRoutes.splashRoute,
      page: () => SplashScreen(),
      bindings: [SplashBinding()],
    ),


    GetPage(
      name: AppRoutes.loginRoute,
      page: () => SingInScreen(),
      bindings: [SignInBinding()],
    ),

    GetPage(
      name: AppRoutes.signupRoute,
      page: () => SignUpScreen(),
      bindings: [SignUpBinding()],
    ),


    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => ForgotPasswordScreen(),
      bindings: [ForgotPasswordBinding()],
    ),

    GetPage(
      name: AppRoutes.videoCallScreen,
      page: () => VideoCallScreen(),
      bindings: [VideoCallBinding()],
    ),

    GetPage(
      name: AppRoutes.createRoomScreen,
      page: () => CreateRoomScreen(),
      bindings: [CreateRoomBinding()],
    ),

    GetPage(
      name: AppRoutes.otpVerificationScreen,
      page: () => OtpVerificationScreen(),
      bindings: [OtpVerificationBinding()],
    ),

    GetPage(
      name: AppRoutes.uploadProfile,
      page: () => UploadProfileScreen(),
      bindings: [UploadProfileBinding()],
    ),

    GetPage(
      name: AppRoutes.homeRoute,
      page: () => HomepageScreen(),
      bindings: [HomepageBinding()],
    ),
  ];
}
