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

    _user.value = UserModel(
      uid: uid,
      nickname: 'Guest',
      temperature: 36.5,
    );
  }

  Future<void> logout() async {
    _user.value = null;
  }
}