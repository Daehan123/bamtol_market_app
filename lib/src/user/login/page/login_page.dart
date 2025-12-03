import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212123), // 배경색 (앱 테마에 맞춤)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 99,
              height: 116,
              child: Image.asset('assets/images/logo_simbol.png'),
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
            ),
            const SizedBox(height: 60),
            
            // [수정] 구글 로그인 버튼 (로고 이미지 경로 전달)
            _loginButton(
              'assets/images/google.png', 
              '구글로 시작하기',
              Colors.white,
              Colors.black,
              () {
                // 구글 로그인 시뮬레이션 -> 회원가입 페이지 이동
                String mockUid = "google_user_${DateTime.now().millisecondsSinceEpoch}";
                Get.toNamed('/signup/$mockUid');
              },
            ),
            const SizedBox(height: 15),
            
            // [수정] 애플 로그인 버튼 (로고 이미지 경로 전달)
            _loginButton(
              'assets/images/apple.png',
              'Apple로 시작하기',
              Colors.black,
              Colors.white,
              () {
                // 애플 로그인 시뮬레이션 -> 회원가입 페이지 이동
                String mockUid = "apple_user_${DateTime.now().millisecondsSinceEpoch}";
                Get.toNamed('/signup/$mockUid');
              },
            ),
          ],
        ),
      ),
    );
  }

  // [수정] 이미지 경로(imagePath)를 받는 파라미터 추가
  Widget _loginButton(String imagePath, String text, Color bgColor, Color textColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
        height: 50,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          // 흰색 배경일 때 버튼이 잘 보이도록 테두리 추가 (구글 버튼용)
          border: bgColor == Colors.white ? Border.all(color: Colors.grey.withOpacity(0.5)) : null,
        ),
        // Row를 사용하여 이미지와 텍스트를 가로로 배치
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
          children: [
            // 로고 이미지
            Image.asset(
              imagePath,
              width: 24, // 로고 크기 조절
              height: 24,
            ),
            const SizedBox(width: 10), // 로고와 글자 사이 간격
            // 버튼 텍스트
            AppFont(
              text,
              color: textColor,
              fontWeight: FontWeight.bold,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}