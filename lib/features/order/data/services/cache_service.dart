import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exception.dart';
import '../../../login/data/model/login_response.dart';
import '../models/delivery_bill.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/return_reason.dart';
import '../models/status_type.dart';


abstract class DeliveryLocalDataSource {
  Future<void> cacheUser(LoginResponse user);
  Future<LoginResponse> getLastLoggedInUser();
  Future<void> cacheBills(List<DeliveryBillModel> bills);
  Future<List<DeliveryBillModel>> getCachedBills();
  Future<void> cacheStatusTypes(List<StatusTypeModel> types);
  Future<List<StatusTypeModel>> getCachedStatusTypes();
  Future<void> cacheReturnReasons(List<ReturnReasonModel> reasons);
  Future<List<ReturnReasonModel>> getCachedReturnReasons();
}

class DeliveryLocalDataSourceImpl implements DeliveryLocalDataSource {
  final SharedPreferences sharedPreferences;

  DeliveryLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(LoginResponse user) async {
    try {
      await sharedPreferences.setString(
          'CACHED_USER',
          jsonEncode({'DeliveryName': user.deliveryName})
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<LoginResponse> getLastLoggedInUser() async {
    try {
      final jsonString = sharedPreferences.getString('CACHED_USER');
      if (jsonString != null) {
        return LoginResponse.fromJson(jsonDecode(jsonString));
      } else {
        throw CacheException(message: 'No cached user found');
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheBills(List<DeliveryBillModel> bills) async {
    try {
      List<Map<String, dynamic>> billsJson = bills.map((bill) =>bill.toJson()).toList();

      await sharedPreferences.setString(
          'CACHED_BILLS',
          jsonEncode(billsJson)
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<DeliveryBillModel>> getCachedBills() async {
    try {
      final jsonString = sharedPreferences.getString('CACHED_BILLS');
      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.map((item) => DeliveryBillModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheStatusTypes(List<StatusTypeModel> types) async {
    try {
      List<Map<String, dynamic>> typesJson = types.map((type) => {
        'TYP_NO': type.typNo,
        'TYP_NM': type.typNm,
      }).toList();

      await sharedPreferences.setString(
          'CACHED_STATUS_TYPES',
          jsonEncode(typesJson)
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<StatusTypeModel>> getCachedStatusTypes() async {
    try {
      final jsonString = sharedPreferences.getString('CACHED_STATUS_TYPES');
      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.map((item) => StatusTypeModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheReturnReasons(List<ReturnReasonModel> reasons) async {
    try {
      List<Map<String, dynamic>> reasonsJson = reasons.map((reason) => {
        'DLVRY_RTRN_RSN': reason.reason,
      }).toList();

      await sharedPreferences.setString(
          'CACHED_RETURN_REASONS',
          jsonEncode(reasonsJson)
      );
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<ReturnReasonModel>> getCachedReturnReasons() async {
    try {
      final jsonString = sharedPreferences.getString('CACHED_RETURN_REASONS');
      if (jsonString != null) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        return decoded.map((item) => ReturnReasonModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw CacheException();
    }
  }
}

class CacheService {
  static const String _ordersCachePrefix = 'delivery_orders_';
  static const Duration _cacheValidity = Duration(hours: 24);

  Future<void> cacheOrders(String deliveryId, List<DeliveryBillModel> orders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': orders.map((order) => order.toJson()).toList(),
      };
      await prefs.setString(
        '$_ordersCachePrefix$deliveryId',
        jsonEncode(cacheData),
      );
    } catch (e) {
      throw Exception('Error caching orders: $e');
    }
  }

  Future<List<DeliveryBillModel>?> getCachedOrders(String deliveryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_ordersCachePrefix$deliveryId';

      if (!prefs.containsKey(cacheKey)) return null;

      final cachedData = prefs.getString(cacheKey);
      if (cachedData == null) return null;

      final decoded = jsonDecode(cachedData);
      final timestamp = decoded['timestamp'] as int;
      final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;

      if (cacheAge > _cacheValidity.inMilliseconds) return null;

      final List<dynamic> ordersJson = decoded['data'];
      return ordersJson.map((json) => DeliveryBillModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error retrieving cached orders: $e');
    }
  }
}