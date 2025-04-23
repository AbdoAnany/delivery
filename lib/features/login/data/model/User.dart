// user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String deliveryNo;
  final String languageNo;
  final String name;

  const User({
    required this.deliveryNo,
    required this.languageNo,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      deliveryNo: json['deliveryNo'] ?? '',
      languageNo: json['languageNo'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'deliveryNo': deliveryNo,
      'languageNo': languageNo,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [deliveryNo, languageNo, name,];
}