import 'package:bamtol_market_app/src/common/controller/authentication_controller.dart';
import 'package:bamtol_market_app/src/home/page/home_page.dart'; // Root 페이지가 있다면 Root()로 변경
import 'package:bamtol_market_app/src/init/page/init_start_page.dart';
import 'package:bamtol_market_app/src/user/login/page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late bool isInitStarted;

  @override
  void initState() {
    super.initState();

    try {
      isInitStarted = Get.find<SharedPreferences>().getBool('isInitStarted') ?? true;
    } catch (e) {
      isInitStarted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var authController = Get.find<AuthenticationController>();

      if (authController.userModel.value != null) {
        return const HomePage(); 
      }

      return isInitStarted
          ? InitStartPage(
              onStart: () {
                setState(() {
                  isInitStarted = false;
                });
                Get.find<SharedPreferences>().setBool('isInitStarted', false);
              },
            )
          : LoginPage();
    });
  }
}