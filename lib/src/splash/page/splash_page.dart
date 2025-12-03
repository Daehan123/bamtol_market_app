import 'dart:async';
import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/controller/authentication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAppStatus();
  }

  Future<void> _checkAppStatus() async {
    // 1. 가짜 데이터 로딩 시간 (1.5초 대기) - 로고 보여주기용
    await Future.delayed(const Duration(milliseconds: 1500));

    // 2. 로그인 상태 확인
    var authController = Get.find<AuthenticationController>();
    
    // 3. 앱 최초 실행 여부 확인 (SharedPreferences)
    // main.dart에서 주입이 안되어있을 수도 있으니 안전하게 호출
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isInitStarted = prefs.getBool('isInitStarted') ?? true;

    if (authController.userModel.value != null) {
      // 이미 로그인 된 유저라면 홈으로
      Get.offAllNamed('/home');
    } else {
      // 로그인 안 된 상태라면
      if (isInitStarted) {
        // 앱을 처음 켰으면 (또는 로그아웃 후 초기화면 보고 싶을 때) -> InitStartPage
        // 하지만 라우트 설정상 InitStartPage가 '/' 라면 그냥 여기서 이동 처리
        // 보통 Splash -> Login 또는 Home으로 나뉩니다.
        
        // 여기서는 로그인 페이지로 이동시킵니다.
        Get.offAllNamed('/login');
      } else {
         Get.offAllNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 복잡한 Listener 제거하고 UI만 표시
    return const Scaffold(
      body: _SplashView(),
    );
  }
}

class _SplashView extends StatelessWidget {
  const _SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 200),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 99,
                height: 116,
                child: Image.asset(
                  'assets/images/logo_simbol.png',
                ),
              ),
              const SizedBox(height: 40),
              const AppFont(
                '당신 근처의 밤톨마켓',
                fontWeight: FontWeight.bold,
                size: 20,
              ),
              const SizedBox(height: 15),
              AppFont(
                '중고 거래부터 동네 정보까지, \n지금 내 동네를 선택하고 시작해보세요!',
                align: TextAlign.center,
                size: 18,
                color: Colors.white.withOpacity(0.6),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 200,
          child: Column(
            children: [
              // 상태 메시지 단순화
              Text(
                '데이터를 불러오는 중입니다...',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                  strokeWidth: 1, color: Colors.white)
            ],
          ),
        )
      ],
    );
  }
}