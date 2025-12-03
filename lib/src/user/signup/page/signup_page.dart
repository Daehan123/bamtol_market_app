import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:bamtol_market_app/src/common/components/btn.dart';
import 'package:bamtol_market_app/src/user/signup/controller/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupPage extends GetView<SignupController> {
  const SignupPage({super.key});

  // 주소 검색 바텀시트
  void _showAddressSearchSheet(BuildContext context) {
    controller.searchText.value = '';
    controller.searchAddress(''); 
    
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white, // 배경이 흰색임
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // [수정] 제목 글자색 검은색으로 지정
            const AppFont('내 동네 찾기', fontWeight: FontWeight.bold, size: 18, color: Colors.black),
            const SizedBox(height: 20),
            
            // 검색 입력창
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                autofocus: true,
                style: const TextStyle(color: Colors.black), // [수정] 입력 글자색 검은색
                onChanged: (value) {
                  controller.searchAddress(value);
                },
                decoration: InputDecoration(
                  hintText: '동명(읍,면)으로 검색 (예: 역삼동)',
                  hintStyle: TextStyle(color: Colors.grey[500]), // 힌트 색상
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            
            // 입력한 주소로 설정 버튼
            GestureDetector(
              onTap: () {
                if (controller.searchText.value.isNotEmpty) {
                  controller.selectAddress(controller.searchText.value);
                } else {
                  Get.snackbar('알림', '주소를 입력해주세요.', snackPosition: SnackPosition.BOTTOM);
                }
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xffED7738),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const AppFont(
                  '입력한 주소로 설정하기',
                  color: Colors.white, 
                  align: TextAlign.center, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            const Divider(height: 1, color: Colors.grey), // 구분선 색상 추가
            
            // 검색 결과 리스트
            Expanded(
              child: Obx(() {
                if (controller.searchAddressResult.isEmpty) {
                   return const Center(
                     child: AppFont(
                       "검색 결과가 없습니다.\n직접 입력 후 위 버튼을 눌러주세요.",
                       color: Colors.black, // [수정] 검은색
                       align: TextAlign.center,
                     )
                   );
                }
                return ListView.separated(
                  itemCount: controller.searchAddressResult.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.grey),
                  itemBuilder: (context, index) {
                    return ListTile(
                      // [수정] 리스트 아이템 글자색을 검은색(Colors.black)으로 지정
                      title: AppFont(
                        controller.searchAddressResult[index], 
                        size: 16,
                        color: Colors.black, 
                      ),
                      onTap: () {
                        controller.selectAddress(controller.searchAddressResult[index]);
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: Get.back,
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        title: const AppFont('회원가입', color: Colors.black, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              // 프로필 이미지
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Icon(Icons.person, size: 60, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              
              // 1. 닉네임 입력
              const AppFont('닉네임', fontWeight: FontWeight.bold, size: 16),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.nicknameController,
                      decoration: InputDecoration(
                        hintText: '닉네임을 입력해주세요',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      controller.checkNickname(controller.nicknameController.text);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xffED7738),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const AppFont('중복확인', color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Obx(() => Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 5.0),
                child: AppFont(
                  controller.nicknameMessage.value,
                  color: controller.isNicknameValid.value 
                      ? Colors.green 
                      : Colors.red,
                  size: 13,
                ),
              )),
              
              const SizedBox(height: 20),

              // 2. 휴대전화 번호
              const AppFont('휴대전화 번호', fontWeight: FontWeight.bold, size: 16),
              const SizedBox(height: 10),
              TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: '휴대전화 번호를 입력해주세요 (- 없이)',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 3. 내 동네 (주소)
              const AppFont('내 동네', fontWeight: FontWeight.bold, size: 16),
              const SizedBox(height: 10),
              TextField(
                controller: controller.addressController,
                readOnly: true,
                onTap: () => _showAddressSearchSheet(context),
                decoration: InputDecoration(
                  hintText: '동명(읍,면)으로 검색',
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // 회원가입 완료 버튼
              Obx(() {
                bool isActive = controller.isNicknameValid.value;
                return Btn(
                  color: isActive ? const Color(0xffED7738) : Colors.grey,
                  onTap: () {
                    controller.submit();
                  },
                  child: const AppFont(
                    '회원가입 완료',
                    color: Colors.white,
                    align: TextAlign.center,
                    fontWeight: FontWeight.bold,
                    size: 18,
                  ),
                );
              }),
              SizedBox(height: Get.mediaQuery.padding.bottom + 20),
            ],
          ),
        ),
      ),
    );
  }
}