// import 'package:delivery/features/login/data/model/Order.dart';
// import 'package:dio/dio.dart';
//
// class ApiService {
//   final Dio _dio = Dio(BaseOptions(
//     baseUrl: 'https://mdev.yemensoft.net:473/',
//     connectTimeout: const Duration(seconds: 30),
//     receiveTimeout: const Duration(seconds: 30),
//   ));
//
//   Future<dynamic> checkDeliveryLogin({
//     required String deliveryNo,
//     required String password,
//     required String languageNo,
//   }) async {
//     try {
//       final response = await _dio.post(
//         '/OnyxDeliveryService/Service.svc/CheckDeliveryLogin',
//         data: {
//           "Value": {
//             "P_LANG_NO": languageNo,
//             "P_DLVRY_NO": deliveryNo,
//             "P_PSSWRD": password,
//           }
//         },
//       );
//       return response.data;
//     } on DioException catch (e) {
//       throw Exception('Login failed: ${e.message}');
//     }
//   }
//
//   Future<List<DeliveryBill>> getDeliveryBillsItems({
//     required String deliveryNo,
//     required String languageNo,
//     String billSerial = '',
//     String processedFlag = '',
//   }) async {
//     try {
//       final response = await _dio.post(
//         '/OnyxDeliveryService/Service.svc/GetDeliveryBillsItems',
//         data: {
//           "Value": {
//             "P_DLVRY_NO": deliveryNo,
//             "P_LANG_NO": languageNo,
//             "P_BILL_SRL": billSerial,
//             "P_PRCSSD_FLG": processedFlag,
//           }
//         },
//       );
//       // Parse response and return List<Order>
//       return [];
//     } on DioException catch (e) {
//       throw Exception('Failed to fetch orders: ${e.message}');
//     }
//   }
// }