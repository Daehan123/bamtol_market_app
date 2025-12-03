import 'dart:typed_data';

import 'package:bamtol_market_app/src/common/components/app_font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class MultifulImageView extends StatefulWidget {
  final List<AssetEntity> initImages;
  const MultifulImageView({super.key, required this.initImages});

  @override
  State<MultifulImageView> createState() => _MultifulImageViewState();
}

class _MultifulImageViewState extends State<MultifulImageView> {
  List<AssetEntity> _images = [];
  List<AssetEntity> _selectedImages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedImages = [...widget.initImages];
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      // 1. 권한 요청
      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      
      // 권한이 없으면 중단
      if (!ps.isAuth && !ps.hasAccess) {
        Get.snackbar('알림', '갤러리 접근 권한을 허용해주세요.');
        return;
      }

      // 2. 앨범 목록 가져오기
      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (albums.isNotEmpty) {
        // 3. 사진 가져오기 (최신 80장)
        final recentImages = await albums[0].getAssetListPaged(page: 0, size: 80);
        
        if (mounted) {
          setState(() {
            _images = recentImages;
          });
        }
      } else {
        // 앨범이 없는 경우
        if (mounted) {
          setState(() {
            _images = [];
          });
        }
      }
    } catch (e) {
      print('갤러리 로드 에러: $e');
    } finally {
      // [중요] 성공하든 실패하든 무조건 로딩 종료
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _onImageTap(AssetEntity image) {
    if (_selectedImages.contains(image)) {
      setState(() {
        _selectedImages.remove(image);
      });
    } else {
      if (_selectedImages.length >= 10) {
        Get.snackbar('알림', '최대 10장까지 선택할 수 있습니다.');
        return;
      }
      setState(() {
        _selectedImages.add(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff212123), // 다크 모드 배경
      appBar: AppBar(
        backgroundColor: const Color(0xff212123),
        elevation: 0,
        centerTitle: true,
        // [수정] 뒤로가기 아이콘을 흰색으로 명시적 지정
        leading: GestureDetector(
          onTap: Get.back,
          child: const Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: const AppFont('사진 선택', fontWeight: FontWeight.bold, size: 18),
        actions: [
          GestureDetector(
            onTap: () {
              Get.back(result: _selectedImages);
            },
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: AppFont(
                '완료',
                color: Color(0xffED7738),
                fontWeight: FontWeight.bold,
                size: 16,
              ),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _images.isEmpty
              ? const Center(
                  child: AppFont(
                    '갤러리에 사진이 없습니다.',
                    color: Colors.white,
                    size: 16,
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                  ),
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    final image = _images[index];
                    final isSelected = _selectedImages.contains(image);
                    final selectIndex = _selectedImages.indexOf(image);

                    return GestureDetector(
                      onTap: () => _onImageTap(image),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // 썸네일 로딩
                          FutureBuilder<Uint8List?>(
                            future: image.thumbnailDataWithSize(
                                const ThumbnailSize(200, 200)),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                );
                              }
                              return Container(color: Colors.grey[800]);
                            },
                          ),
                          // 선택 시 어두운 오버레이
                          if (isSelected)
                            Container(
                              color: Colors.black.withOpacity(0.4),
                            ),
                          // 선택 번호 표시
                          if (isSelected)
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: const Color(0xffED7738),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white),
                                ),
                                child: Center(
                                  child: Text(
                                    '${selectIndex + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}