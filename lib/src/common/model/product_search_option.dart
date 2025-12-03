import 'package:bamtol_market_app/src/common/enum/market_enum.dart';
import 'package:equatable/equatable.dart';

class ProductSearchOption extends Equatable {
  // Firestore 객체 대신 String ID나 int Index 사용
  final dynamic lastItem; 
  final List<ProductStatusType>? status;
  final String? ownerId;

  const ProductSearchOption({
    this.lastItem,
    this.status,
    this.ownerId,
  });

  ProductSearchOption copyWith({
    dynamic lastItem,
    String? ownerId,
    List<ProductStatusType>? status,
  }) {
    return ProductSearchOption(
      lastItem: lastItem,
      status: status ?? this.status,
      ownerId: ownerId ?? this.ownerId,
    );
  }

  // Firestore 쿼리 생성 로직 제거 (Repository에서 필터링 처리)

  @override
  List<Object?> get props => [
        lastItem,
        status,
        ownerId,
      ];
}