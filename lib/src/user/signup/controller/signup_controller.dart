import 'package:bamtol_market_app/src/common/controller/authentication_controller.dart';
import 'package:bamtol_market_app/src/user/model/user_model.dart';
import 'package:bamtol_market_app/src/user/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  final UserRepository _userRepository;
  final String uid;

  TextEditingController nicknameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  
  RxBool isNicknameValid = false.obs;
  RxString nicknameMessage = ''.obs;

  RxList<String> searchAddressResult = <String>[].obs;
  RxString searchText = ''.obs;

  SignupController(this._userRepository, this.uid);

  void checkNickname(String nickname) async {
    if(nickname.trim().isEmpty) {
      isNicknameValid.value = false;
      nicknameMessage.value = '닉네임을 입력해주세요.';
      return;
    }
    
    bool isAvailable = await _userRepository.checkDuplicationNickName(nickname);
    
    if (isAvailable) {
      isNicknameValid.value = true;
      nicknameMessage.value = '사용 가능한 닉네임입니다.';
    } else {
      isNicknameValid.value = false;
      nicknameMessage.value = '이미 사용 중인 닉네임입니다.';
    }
  }

  // [수정] 주소 검색 함수
  void searchAddress(String query) {
    searchText.value = query;

    // 검색어가 비어있으면 -> "전체 목록"을 보여줌 (기존에는 비웠음)
    if (query.isEmpty) {
      searchAddressResult.assignAll(_koreaTowns);
      return;
    }
    
    // 검색어가 있으면 -> 포함된 동네만 필터링
    List<String> result = _koreaTowns.where((town) => town.contains(query)).toList();
    searchAddressResult.assignAll(result);
  }

  void selectAddress(String address) {
    if (address.isEmpty) return;
    addressController.text = address;
    searchAddressResult.clear();
    searchText.value = '';
    Get.back();
  }

  Future<void> submit() async {
    if (!isNicknameValid.value) {
       Get.snackbar('알림', '먼저 닉네임 중복 확인을 해주세요.', snackPosition: SnackPosition.BOTTOM);
       return;
    }
    if (nicknameController.text.trim().isEmpty) {
       Get.snackbar('알림', '닉네임을 입력해주세요.', snackPosition: SnackPosition.BOTTOM);
       return;
    }
    if (phoneController.text.trim().isEmpty) {
       Get.snackbar('알림', '전화번호를 입력해주세요.', snackPosition: SnackPosition.BOTTOM);
       return;
    }
    if (addressController.text.trim().isEmpty) {
       Get.snackbar('알림', '동네를 선택해주세요.', snackPosition: SnackPosition.BOTTOM);
       return;
    }

    var newUser = UserModel(
      uid: uid,
      nickname: nicknameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      address: addressController.text.trim(),
      temperature: 36.5,
      createdAt: DateTime.now(),
    );

    var result = await _userRepository.signup(newUser);

    if (result != null) {
      Get.find<AuthenticationController>().manualLogin(newUser);
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('오류', '회원가입 처리에 실패했습니다. 다시 시도해주세요.');
    }
  }

  final List<String> _koreaTowns = [
    '서울시 강남구 역삼동',
    '서울시 강남구 삼성동',
    '서울시 강남구 청담동',
    '서울시 강남구 신사동',
    '서울시 서초구 서초동',
    '서울시 서초구 반포동',
    '서울시 서초구 방배동',
    '서울시 송파구 잠실동',
    '서울시 마포구 서교동',
    '서울시 마포구 망원동',
    '경기도 성남시 분당구 정자동',
    '경기도 성남시 분당구 판교동',
    '경기도 용인시 수지구 풍덕천동',
    '부산시 해운대구 우동',
    '부산시 해운대구 중동',
    '제주시 아라동',
    '제주시 연동',
    '제주시 노형동',
    '제주시 이도동',
  ];
}