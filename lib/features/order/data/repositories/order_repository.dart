import '../models/order.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';

class OrderRepository {
  final ApiService _apiService = ApiService();
  final CacheService _cacheService = CacheService();

  Future<List<Order>> getOrders(String deliveryId) async {
    try {
      // Try to load cached data first
      // final cachedOrders = await _cacheService.getCachedOrders(deliveryId);
      // if (cachedOrders != null && cachedOrders.isNotEmpty) {
      //   return cachedOrders;
      // }

      // Then fetch fresh data
      final freshOrders = await _apiService.getDeliveryBills(deliveryId);
      if (freshOrders.isNotEmpty) {
        await _cacheService.cacheOrders(deliveryId, freshOrders);
      }
      return freshOrders;
    } catch (e) {
      rethrow;
    }
  }
}