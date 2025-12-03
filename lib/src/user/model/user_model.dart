import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String nickname;
  final String? phoneNumber; // [추가] 여기가 있어야 컨트롤러 오류가 사라짐
  final String? address;     // [추가]
  final double? temperature; // [추가]
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    required this.nickname,
    this.phoneNumber,
    this.address,
    this.temperature,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      nickname: json['nickname'] as String,
      phoneNumber: json['phoneNumber'] as String?, // [추가]
      address: json['address'] as String?,         // [추가]
      // 숫자가 들어올 때 안전하게 double로 변환 (기본값 36.5)
      temperature: (json['temperature'] as num?)?.toDouble() ?? 36.5,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'nickname': nickname,
      'phoneNumber': phoneNumber, // [추가]
      'address': address,         // [추가]
      'temperature': temperature, // [추가]
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        uid,
        nickname,
        phoneNumber,
        address,
        temperature,
        createdAt,
      ];
}