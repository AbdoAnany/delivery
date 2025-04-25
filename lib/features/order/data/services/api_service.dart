import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order.dart';

class ApiService {
  static const String _baseUrl =
      'http://mdev.yemensoft.net:8087/OnyxDeliveryService/Service.svc';

  Future<List<Order>> getDeliveryBills(
      String deliveryNo, {
        String billSrl = "",
        String processedFlag = "",
        String langNo = "1",
      }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/GetDeliveryBillsItems'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'Value': {
            'P_DLVRY_NO': deliveryNo,
            'P_LANG_NO': langNo,
            'P_BILL_SRL': billSrl,
            'P_PRCSSD_FLG': processedFlag,
          },
        }),
      );

      final data = jsonDecode(response.body);
      if (data['Result']['ErrNo'] != 0) {
        throw Exception(data['Result']['ErrMsg'] ?? 'API Error');
      }

      final List<dynamic> ordersJson = data['Data']['DeliveryBills'] ?? [];
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get delivery bills: $e');
    }
  }

// Other API methods...
}