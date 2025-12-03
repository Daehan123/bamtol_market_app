import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:get/get.dart';

class AuthenticationRepository extends GetxService {
  final Rx<UserModel?> _user = Rx<UserModel?>(null);

  AuthenticationRepository();

  Stream<UserModel?> get user => _user.stream;

  Future<void> signInWithGoogle() async {
    _fakeLogin('google_user_uid');
  }

  Future<void> signInWithApple() async {
    _fakeLogin('apple_user_uid');
  }

  void _fakeLogin(String uid) {
    // [수정] UserModel 생성 시 필수값(nickname)을 넣어줘야 오류가 안 납니다.
    // 여기는 "로그인 시늉"만 하는 곳이므로 임시 값을 넣어줍니다.
    _user.value = UserModel(
      uid: uid,
      nickname: 'Guest', // 임시 닉네임
      temperature: 36.5,
    );
  }

  Future<void> logout() async {
    _user.value = null;
  }
}