import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:get/get.dart';

class UserRepository extends GetxService {
  final List<UserModel> _mockUsers = [];

  UserRepository();

  Future<UserModel?> findUserOne(String uid) async {
    try {
      final user = _mockUsers.firstWhereOrNull((user) => user.uid == uid);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkDuplicationNickName(String nickname) async {
    try {
      final user = _mockUsers.firstWhereOrNull((user) => user.nickname == nickname);
      return user == null;
    } catch (e) {
      return false;
    }
  }

  Future<String?> signup(UserModel user) async {
    try {
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