import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String nickname;
  final String? phoneNumber; 
  final String? address;     
  final double? temperature; 
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
      phoneNumber: json['phoneNumber'] as String?, 
      address: json['address'] as String?,
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
      'phoneNumber': phoneNumber, 
      'address': address,
      'temperature': temperature,
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