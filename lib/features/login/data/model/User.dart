// user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String deliveryNo;
  final String languageNo;
  final String name;
  final String token;

  const User({
    required this.deliveryNo,
    required this.languageNo,
    required this.name,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      deliveryNo: json['deliveryNo'] ?? '',
      languageNo: json['languageNo'] ?? '',
      name: json['name'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliveryNo': deliveryNo,
      'languageNo': languageNo,
      'name': name,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [deliveryNo, languageNo, name, token];
}