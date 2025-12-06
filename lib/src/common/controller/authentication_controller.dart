import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:bamtol_market_app/src/user/repository/authentication_repository.dart';
import 'package:bamtol_market_app/src/user/repository/user_repository.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;

  // 로그인된 유저 정보를 담는 변수 (null이면 비로그인 상태)
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  AuthenticationController(
      this._authenticationRepository, this._userRepository);

  @override
  void onInit() {
    super.onInit();
  }

  void manualLogin(UserModel newUser) {
    userModel.value = newUser;
  }

  Future<void> logout() async {
    await _authenticationRepository.logout();
    userModel.value = null;
  }
}