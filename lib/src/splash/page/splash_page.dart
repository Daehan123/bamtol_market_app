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
    await Future.delayed(const Duration(milliseconds: 1500));

    var authController = Get.find<AuthenticationController>();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isInitStarted = prefs.getBool('isInitStarted') ?? true;

    if (authController.userModel.value != null) {
      Get.offAllNamed('/home');
    } else {
      if (isInitStarted) {

        Get.offAllNamed('/login');
      } else {
         Get.offAllNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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