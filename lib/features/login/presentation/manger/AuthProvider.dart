import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/remote/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService apiService;
  final SharedPreferences sharedPreferences;
  
  bool _isAuthenticated = false;
  String? _deliveryNo;
  String? _languageNo;
  String? _token;

  AuthProvider({
    required this.apiService,
    required this.sharedPreferences,
  }) {
    // Load saved credentials if available
    _loadSavedCredentials();
  }

  bool get isAuthenticated => _isAuthenticated;
  String? get deliveryNo => _deliveryNo;
  String? get languageNo => _languageNo;

  Future<void> _loadSavedCredentials() async {
    _deliveryNo = sharedPreferences.getString('deliveryNo');
    _languageNo = sharedPreferences.getString('languageNo') ?? '2'; // Default to 2
    _token = sharedPreferences.getString('token');
    _isAuthenticated = _token != null;
    notifyListeners();
  }

  Future<void> login({
    required String deliveryNo,
    required String password,
    required String languageNo,
  }) async {
    try {
      final response = await apiService.checkDeliveryLogin(
        deliveryNo: deliveryNo,
        password: password,
        languageNo: languageNo,
      );

      // Assuming response contains token and is successful
      _token = response['token']; // Adjust based on actual API response
      _deliveryNo = deliveryNo;
      _languageNo = languageNo;
      _isAuthenticated = true;

      // Save credentials
      await sharedPreferences.setString('deliveryNo', deliveryNo);
      await sharedPreferences.setString('languageNo', languageNo);
      await sharedPreferences.setString('token', _token!);

      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      _token = null;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    await sharedPreferences.remove('token');
    _isAuthenticated = false;
    _token = null;
    notifyListeners();
  }

  Future<void> changeLanguage(String languageNo) async {
    _languageNo = languageNo;
    await sharedPreferences.setString('languageNo', languageNo);
    notifyListeners();
  }
}