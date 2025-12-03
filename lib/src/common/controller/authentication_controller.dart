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

  // [수정] 복잡한 스트림 리스너 제거. 단순 유저 저장용 함수 추가.
  void manualLogin(UserModel newUser) {
    userModel.value = newUser;
  }

  Future<void> logout() async {
    // 저장소 레벨 로그아웃 (필요시)
    await _authenticationRepository.logout();
    // 상태 비우기 -> 앱이 이를 감지하고 로그인/시작 화면으로 이동
    userModel.value = null;
  }
}