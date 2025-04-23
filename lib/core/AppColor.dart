// constants.dart
import 'package:flutter/material.dart';

class AppColors {
  static Color primary = const Color(0xFFD42A0F);
  static Color primaryDark = const Color(0xFF004F62);
  static Color textPrimary = const Color(0xFF004F62);
  static Color textSecondary = const Color(0xFF707070);
  static Color background = const Color(0xFFF9F9F9);
  static Color fillColor2 = const Color(0xFFF4F4F4);
  static Color fillColor = const Color(0xFFF1F5FB);
  static Color babyBlue = const Color(0xFFE9FAFF);

  static Color black=Colors.black;

}

class ApiConstants {
  static const String baseUrl = 'https://mdev.yemensoft.net:473/OnyxDeliveryService/Service.svc';
  static const String loginEndpoint = '/CheckDeliveryLogin';
  static const String deliveryBillsEndpoint = '/GetDeliveryBillsItems';
  static const String deliveryStatusTypesEndpoint = '/GetDeliveryStatusTypes';
  static const String returnBillReasonsEndpoint = '/GetReturnBillReasons';
  static const String updateDeliveryBillStatusEndpoint = '/UpdateDeliveryBillStatus';
}

class AppImages {
  static const String logo = 'assets/images/logo.png';
  static const String tawen = 'assets/images/tawen.png';
  static const String background = 'assets/images/background.png';
  static const String deliveryIcon = 'assets/images/delivery.png';
  static const String delivaryBuke = 'assets/images/delivary_buke.png';
  static const String arabic = 'assets/images/arabic.png';
  static const String english = 'assets/images/english.png';
  static const String ic_circle1 = 'assets/images/ic_circle1.png';
  static const String ic_circlex2 = 'assets/images/ic_circlex2.png';
  static const String ic_emptyorder = 'assets/images/ic_emptyorder.png';
  static const String ic_language = 'assets/images/ic_language.png';
  static const String man = 'assets/images/man.png';
  static const String search = 'assets/images/search.png';
}