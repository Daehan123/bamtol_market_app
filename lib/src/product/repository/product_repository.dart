import 'package:bamtol_market_app/src/common/model/product.dart';
import 'package:bamtol_market_app/src/common/model/product_search_option.dart';
import 'package:get/get.dart';

class ProductRepository extends GetxService {
  final List<Product> _mockProducts = [];

  ProductRepository();

  Future<String?> saveProduct(Map<String, dynamic> data) async {
    try {
      String newId = DateTime.now().millisecondsSinceEpoch.toString();

      if (!data.containsKey('createdAt')) {
        data['createdAt'] = DateTime.now().toIso8601String();
      }

      if (!data.containsKey('updatedAt')) {
        data['updatedAt'] = DateTime.now().toIso8601String();
      }

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
      List<Product> filtered = List.from(_mockProducts);

      if (searchOption.ownerId != null) {
        filtered = filtered.where((p) => p.owner?.uid == searchOption.ownerId).toList();
      }

      if (searchOption.status != null && searchOption.status!.isNotEmpty) {
        filtered = filtered.where((p) {
          if (p.status == null) return false;
          return searchOption.status!.contains(p.status);
        }).toList();
      }

      filtered.sort((a, b) {
        DateTime timeA = a.createdAt ?? DateTime(2000);
        DateTime timeB = b.createdAt ?? DateTime(2000);
        return timeB.compareTo(timeA);
      });

      int start = 0;
      if (searchOption.lastItem is int) {
        start = searchOption.lastItem as int;
      }

      int end = start + 7;
      if (end > filtered.length) end = filtered.length;

      if (start >= filtered.length) {
         return (list: <Product>[], lastItem: null);
      }

      var resultList = filtered.sublist(start, end);

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