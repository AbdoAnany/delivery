// constants.dart
import 'package:flutter/material.dart';

class AppColors {
  static Color primary = const Color(0xFFD42A0F);
  static Color primaryDark = const Color(0xFF004F62);
  static Color textPrimary = const Color(0xFF004F62);
  static Color textSecondary = const Color(0xFF707070);
  static Color background = const Color(0xFFF9F9F9);
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
  static const String splash = 'assets/images/splash.png';
  static const String background = 'assets/images/background.png';
  static const String deliveryIcon = 'assets/images/delivery.png';
  static const String profileIcon = 'assets/images/profile_icon.png';
}