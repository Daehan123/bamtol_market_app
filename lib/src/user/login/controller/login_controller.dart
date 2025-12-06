import 'package:get/get.dart';

class LoginController extends GetxController {

  void googleLogin() {
    Get.toNamed('/signup/google_login_temp_uid');
  }

  void appleLogin() {
    Get.toNamed('/signup/apple_login_temp_uid');
  }
}