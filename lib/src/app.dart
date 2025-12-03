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
    // main.dart에서 prefs를 주입받지 못했다면 여기서 인스턴스를 가져와야 할 수도 있습니다.
    // 일단 전역 변수나 Get.find 등으로 prefs를 접근한다고 가정하거나,
    // 아래처럼 안전하게 처리합니다.
    try {
      isInitStarted = Get.find<SharedPreferences>().getBool('isInitStarted') ?? true;
    } catch (e) {
      isInitStarted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // GetX Obx를 사용하여 로그인 상태 변화를 감지합니다.
    return Obx(() {
      var authController = Get.find<AuthenticationController>();

      // 1. 이미 로그인 된 상태라면 바로 홈으로
      if (authController.userModel.value != null) {
        // Home() 대신 Root() 페이지가 있다면 Root()를 쓰세요.
        return const HomePage(); 
      }

      // 2. 로그인이 안 된 상태라면
      // isInitStarted(처음 킴) 여부에 따라 시작 페이지 vs 로그인 페이지 분기
      return isInitStarted
          ? InitStartPage(
              onStart: () {
                setState(() {
                  isInitStarted = false;
                });
                // SharedPreferences 저장
                Get.find<SharedPreferences>().setBool('isInitStarted', false);
              },
            )
          : const LoginPage(); // 시작하기를 누르면 로그인 페이지가 나옴
    });
  }
}