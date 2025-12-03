import 'package:bamtol_market_app/src/common/model/product.dart';
import 'package:bamtol_market_app/src/common/model/product_search_option.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxService {
  // 메모리 상품 저장소 (앱 재시작 시 초기화됨)
  final List<Product> _mockProducts = [];

  ProductRepository();

  Future<String?> saveProduct(Map<String, dynamic> data) async {
    try {
      // ID 생성
      String newId = DateTime.now().millisecondsSinceEpoch.toString();

      // data 맵에 createdAt이 없다면 String 형태로 추가 (Product.fromJson 대응)
      if (!data.containsKey('createdAt')) {
        data['createdAt'] = DateTime.now().toIso8601String();
      }
      
      // toMap에서 updatedAt을 처리하지만, raw Map으로 들어올 때를 대비
      if (!data.containsKey('updatedAt')) {
        data['updatedAt'] = DateTime.now().toIso8601String();
      }

      // Product 객체 생성 및 저장
      Product newProduct = Product.fromJson(newId, data);
      _mockProducts.add(newProduct);

      return newId;
    } catch (e) {
      print('Save Product Error: $e');
      return null;
    }
  }

  Future<({List<Product> list, dynamic lastItem})> getProducts(
      ProductSearchOption searchOption) async {
    try {
      // 1. 전체 리스트 복사
      List<Product> filtered = List.from(_mockProducts);

      // 2. 필터링 (ownerId)
      // [수정] Product에는 ownerId 필드가 없고 owner(UserModel)가 있음.
      // owner 객체 안의 uid와 비교해야 함.
      if (searchOption.ownerId != null) {
        filtered = filtered.where((p) => p.owner?.uid == searchOption.ownerId).toList();
      }

      // 3. 필터링 (Status)
      // searchOption.status는 List<ProductStatusType>임.
      if (searchOption.status != null && searchOption.status!.isNotEmpty) {
        filtered = filtered.where((p) {
          if (p.status == null) return false;
          return searchOption.status!.contains(p.status);
        }).toList();
      }

      // 4. 정렬 (최신순: createdAt 기준 내림차순)
      filtered.sort((a, b) {
        DateTime timeA = a.createdAt ?? DateTime(2000);
        DateTime timeB = b.createdAt ?? DateTime(2000);
        return timeB.compareTo(timeA); // 내림차순
      });

      // 5. 페이지네이션 (Index 기반)
      int start = 0;
      if (searchOption.lastItem is int) {
        start = searchOption.lastItem as int;
      }

      int end = start + 7;
      if (end > filtered.length) end = filtered.length;

      // 범위가 안 맞으면 빈 리스트 리턴
      if (start >= filtered.length) {
         return (list: <Product>[], lastItem: null);
      }

      var resultList = filtered.sublist(start, end);

      // 다음 페이지 커서 설정
      dynamic nextCursor;
      if (end < filtered.length) {
        nextCursor = end;
      }

      return (
        list: resultList,
        lastItem: nextCursor
      );
    } catch (e) {
      print('Get Products Error: $e');
      return (list: <Product>[], lastItem: null);
    }
  }
}