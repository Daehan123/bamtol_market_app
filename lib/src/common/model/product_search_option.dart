import 'package:bamtol_market_app/src/common/enum/market_enum.dart';
import 'package:equatable/equatable.dart';

class ProductSearchOption extends Equatable {
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

  @override
  List<Object?> get props => [
        lastItem,
        status,
        ownerId,
      ];
}