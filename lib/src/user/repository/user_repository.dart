import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:get/get.dart';

class UserRepository extends GetxService {
  // 메모리 DB (앱 끄면 사라짐, 켜져있는 동안 유지)
  final List<UserModel> _mockUsers = [];

  UserRepository();

  // 유저 정보 찾기
  Future<UserModel?> findUserOne(String uid) async {
    try {
      // 저장된 리스트에서 uid가 같은 유저 찾기
      final user = _mockUsers.firstWhereOrNull((user) => user.uid == uid);
      return user;
    } catch (e) {
      return null;
    }
  }

  // 닉네임 중복 체크
  Future<bool> checkDuplicationNickName(String nickname) async {
    try {
      final user = _mockUsers.firstWhereOrNull((user) => user.nickname == nickname);
      return user == null; // null이면 중복 없음(사용 가능)
    } catch (e) {
      return false;
    }
  }

  // 회원가입 (저장)
  Future<String?> signup(UserModel user) async {
    try {
      // [중요] 이미 있는 유저라면 덮어쓰기 (업데이트 효과)
      int index = _mockUsers.indexWhere((u) => u.uid == user.uid);
      if (index != -1) {
        _mockUsers[index] = user;
      } else {
        _mockUsers.add(user);
      }
      return user.uid;
    } catch (e) {
      return null;
    }
  }
}