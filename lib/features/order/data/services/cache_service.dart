import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

class CacheService {
  static const String _ordersCachePrefix = 'delivery_orders_';
  static const Duration _cacheValidity = Duration(hours: 24);

  Future<void> cacheOrders(String deliveryId, List<Order> orders) async {
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

  Future<List<Order>?> getCachedOrders(String deliveryId) async {
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
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error retrieving cached orders: $e');
    }
  }
}