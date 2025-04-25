class LoginResponse {
  final String deliveryName;

  LoginResponse({required this.deliveryName});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      deliveryName: json['DeliveryName'] ?? '',
    );
  }
}
