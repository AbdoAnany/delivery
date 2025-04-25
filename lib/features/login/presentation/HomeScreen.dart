// // main.dart
// import 'dart:convert';
//
// import 'package:delivery/core/AppColor.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'screens/orders_screen.dart';
// // import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../order/data/models/order.dart';
// // import 'package:flutter/foundation.dart';
// // import '../models/order.dart';
//
// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
// //   SystemChrome.setSystemUIOverlayStyle(
// //     const SystemUiOverlayStyle(
// //       statusBarColor: Colors.transparent,
// //       statusBarIconBrightness: Brightness.light,
// //     ),
// //   );
// //   runApp(const MyApp());
// // }
//
// class OrdersScreen1 extends StatefulWidget {
//   const OrdersScreen1({Key? key}) : super(key: key);
//
//   @override
//   State<OrdersScreen1> createState() => _OrdersScreenState();
// }
//
// class _OrdersScreenState extends State<OrdersScreen1>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   List<Order> _orders = [];
//   bool _isLoading = true;
//   String? _errorMessage;
//   final String _deliveryId = '1010'; // Would come from login
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(_handleTabChange);
//     _fetchOrders();
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   void _handleTabChange() {
//     if (!_tabController.indexIsChanging) {
//       setState(() {
//         _filterOrders();
//       });
//     }
//   }
//
//   Future<void> _fetchOrders() async {
//     if (mounted) {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//       });
//     }
//
//     try {
//       // Try to load cached data first
//       final cachedOrders = await CacheService.getCachedOrders(_deliveryId);
//       if (cachedOrders != null && cachedOrders.isNotEmpty) {
//         if (mounted) {
//           setState(() {
//             _orders = cachedOrders;
//             _isLoading = false;
//           });
//         }
//       }
//
//       // Then fetch fresh data
//       final freshOrders = await ApiService.getDeliveryBills(_deliveryId);
//       if (freshOrders != null) {
//         await CacheService.cacheOrders(_deliveryId, freshOrders);
//         if (mounted) {
//           setState(() {
//             _orders = freshOrders;
//             _isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           _errorMessage = 'Failed to load orders. Please try again.';
//           _isLoading = false;
//         });
//       }
//       debugPrint('Error fetching orders: $e');
//     }
//   }
//
//   List<Order> _filterOrders() {
//     if (_orders.isEmpty) return [];
//
//     if (_tabController.index == 0) {
//       // New tab
//       return _orders
//           .where((order) => order.status.toLowerCase() == 'new')
//           .toList();
//     } else {
//       // Others tab
//       return _orders
//           .where((order) => order.status.toLowerCase() != 'new')
//           .toList();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final filteredOrders = _filterOrders();
//
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       body: Column(
//         children: [
//           Container(
//             height: 127.h,
//             color: AppColors.primary,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Padding(
//                   padding:  EdgeInsets.only(left: 16.0.w,
//                   top: 46.h
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Ahmed',
//                         style: TextStyle(
//                           height: .5,
//                           fontSize: 25.sp,
//                           color: AppColors.white,
//                           fontWeight: FontWeight.w300,
//                         ),
//                       ),
//                       Text(
//                         'Othman',
//                         style: TextStyle(
//                           fontSize: 25.sp,
//                           color: AppColors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Stack(
//                   clipBehavior: Clip.none,
//                   alignment: Alignment.center,
//                   children: [
//                     Image.asset(
//                       AppImages.ic_circle1,
//                       fit: BoxFit.contain,
//                       // width: 121.w,
//                       //
//                       //
//                       // height: 127.h,
//                     ),
//                     Positioned(
//                       left: -70.w,
//                         bottom: 0,
//                       child: Image.asset(
//                         AppImages.man,
//                         fit: BoxFit.contain,
//                         width: 134.w,
//                         height: 108.h,
//                       ),
//                     )
//                   ],
//                 ),
//
//
//               ],
//             ),
//           ),
//           Container(
//             height: 36.h,
//             width: 220.w,
//             margin: EdgeInsets.only(top: 16.h, bottom: 28.h),
//             decoration: BoxDecoration(
//               color: AppColors.white,
//               borderRadius: BorderRadius.circular(30),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 8,
//                   offset: Offset(0, 2),
//                 ),
//               ],
//             ),
//             child: TabBar(
//               controller: _tabController,
//               indicator: BoxDecoration(
//                 color: Color(0xFF2C3E50), // dark blue
//                 borderRadius: BorderRadius.circular(30),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 4,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               labelColor: Colors.white,
//               padding: EdgeInsets.zero,
//               indicatorPadding: EdgeInsets.zero,
//               indicatorSize: TabBarIndicatorSize.tab,
//               dividerHeight: 0,
//
//               unselectedLabelColor: Color(0xFF2C3E50),
//               labelStyle: TextStyle(fontWeight: FontWeight.bold),
//               // indicatorPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//               tabs: [
//                 Tab(
//                   child: Container(
//                     margin: EdgeInsets.zero,
//                     padding: EdgeInsets.all(8),
//                     width: double.infinity,
//                     child: Center(
//                       child: Text(
//                         'New',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Tab(
//                   child: Container(
//                     padding: EdgeInsets.all(8),
//                     width: double.infinity,
//                     child: Center(
//                       child: Text(
//                         'Others',
//                         style: TextStyle(
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child:
//             _isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : _errorMessage != null
//                 ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     _errorMessage!,
//                     style: const TextStyle(color: Color(0xFFE74C3C)),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _fetchOrders,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF3498DB),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 10,
//                       ),
//                     ),
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             )
//                 : filteredOrders.isEmpty
//                 ? const EmptyState()
//                 : Container(
//               child: RefreshIndicator(
//                 onRefresh: _fetchOrders,
//                 child: ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: filteredOrders.length,
//                   itemBuilder: (context, index) {
//                     return OrderItem(
//                       order: filteredOrders[index],
//                       onTap: (order) {
//                         // Navigate to order details (not implemented)
//                         debugPrint(
//                           'Order tapped: ${order.billNumber}',
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // models/order.dart
// // class Order {
// //   final String billNumber;
// //   final String status;
// //   final double totalAmount;
// //   final String date;
// //
// //   Order({
// //     required this.billNumber,
// //     required this.status,
// //     required this.totalAmount,
// //     required this.date,
// //   });
// //
// //   factory Order.fromJson(Map<String, dynamic> json) {
// //     return Order(
// //       billNumber: json['BILL_SRL'] ?? '',
// //       status: json['STATUS'] ?? 'New',
// //       totalAmount: double.tryParse(json['BILL_AMT']?.toString() ?? '0') ?? 0.0,
// //       date: json['BILL_DATE'] ?? '',
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'BILL_SRL': billNumber,
// //       'STATUS': status,
// //       'BILL_AMT': totalAmount,
// //       'BILL_DATE': date,
// //     };
// //   }
// // }
//
// // services/api_service.dart
//
// class ApiService {
//   static const String baseUrl =
//       'http://mdev.yemensoft.net:8087/OnyxDeliveryService/Service.svc';
//
//   static Future<bool> login(
//     String deliveryNo,
//     String password, {
//     String langNo = "1",
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/CheckDeliveryLogin'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'Value': {
//             'P_LANG_NO': langNo,
//             'P_DLVRY_NO': deliveryNo,
//             'P_PSSWRD': password,
//           },
//         }),
//       );
//
//       final data = jsonDecode(response.body);
//       return data['ErrorCode'] == 0;
//     } catch (e) {
//       debugPrint('Login error: $e');
//       throw Exception('Failed to login');
//     }
//   }
//
//   static Future<bool> changePassword(
//     String deliveryNo,
//     String oldPassword,
//     String newPassword, {
//     String langNo = "1",
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/ChangeDeliveryPassword'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'Value': {
//             'P_LANG_NO': langNo,
//             'P_DLVRY_NO': deliveryNo,
//             'P_OLD_PSSWRD': oldPassword,
//             'P_NEW_PSSWRD': newPassword,
//           },
//         }),
//       );
//
//       final data = jsonDecode(response.body);
//       return data['ErrorCode'] == 0;
//     } catch (e) {
//       debugPrint('Change password error: $e');
//       throw Exception('Failed to change password');
//     }
//   }
//
//   static Future<List<Order>> getDeliveryBills(
//     String deliveryNo, {
//     String billSrl = "",
//     String processedFlag = "",
//     String langNo = "1",
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/GetDeliveryBillsItems'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'Value': {
//             'P_DLVRY_NO': deliveryNo,
//             'P_LANG_NO': langNo,
//             'P_BILL_SRL': billSrl,
//             'P_PRCSSD_FLG': processedFlag,
//           },
//         }),
//       );
//
//       final data = jsonDecode(response.body);
//       print(data);
//       if (data['Result']['ErrNo'] != 0) {
//         throw Exception(data['Result']['ErrMsg'] ?? 'API Error');
//       }
//
//       final List<dynamic> ordersJson = data['Data']['DeliveryBills'] ?? [];
//       return ordersJson.map((json) => Order.fromJson(json)).toList();
//     } catch (e) {
//       debugPrint('Get delivery bills error: $e');
//       throw Exception('Failed to get delivery bills');
//     }
//   }
//
//   static Future<List<Map<String, dynamic>>> getStatusTypes({
//     String langNo = "1",
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/GetDeliveryStatusTypes'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'Value': {'P_LANG_NO': langNo},
//         }),
//       );
//
//       final data = jsonDecode(response.body);
//       if (data['ErrorCode'] != 0) {
//         throw Exception(data['ErrorMessage'] ?? 'API Error');
//       }
//
//       return List<Map<String, dynamic>>.from(data['Result'] ?? []);
//     } catch (e) {
//       debugPrint('Get status types error: $e');
//       throw Exception('Failed to get status types');
//     }
//   }
//
//   static Future<List<Map<String, dynamic>>> getReturnReasons({
//     String langNo = "1",
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/GetReturnBillReasons'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'Value': {'P_LANG_NO': langNo},
//         }),
//       );
//
//       final data = jsonDecode(response.body);
//       if (data['ErrorCode'] != 0) {
//         throw Exception(data['ErrorMessage'] ?? 'API Error');
//       }
//
//       return List<Map<String, dynamic>>.from(data['Result'] ?? []);
//     } catch (e) {
//       debugPrint('Get return reasons error: $e');
//       throw Exception('Failed to get return reasons');
//     }
//   }
//
//   static Future<bool> updateBillStatus(
//     String billSrl,
//     String statusFlag, {
//     String returnReason = "",
//     String langNo = "1",
//   }) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/UpdateDeliveryBillStatus'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'Value': {
//             'P_LANG_NO': langNo,
//             'P_BILL_SRL': billSrl,
//             'P_DLVRY_STATUS_FLG': statusFlag,
//             'P_DLVRY_RTRN_RSN': returnReason,
//           },
//         }),
//       );
//
//       final data = jsonDecode(response.body);
//       return data['ErrorCode'] == 0;
//     } catch (e) {
//       debugPrint('Update bill status error: $e');
//       throw Exception('Failed to update bill status');
//     }
//   }
// }
//
// class CacheService {
//   static const String _ordersCachePrefix = 'delivery_orders_';
//   static const Duration _cacheValidity = Duration(hours: 24);
//
//   static Future<void> cacheOrders(String deliveryId, List<Order> orders) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final cacheData = {
//         'timestamp': DateTime.now().millisecondsSinceEpoch,
//         'data': orders.map((order) => order.toJson()).toList(),
//       };
//
//       await prefs.setString(
//         '$_ordersCachePrefix$deliveryId',
//         jsonEncode(cacheData),
//       );
//     } catch (e) {
//       print('Error caching orders: $e');
//     }
//   }
//
//   static Future<List<Order>?> getCachedOrders(String deliveryId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final cacheKey = '$_ordersCachePrefix$deliveryId';
//
//       if (!prefs.containsKey(cacheKey)) {
//         return null;
//       }
//
//       final cachedData = prefs.getString(cacheKey);
//       if (cachedData == null) {
//         return null;
//       }
//
//       final decoded = jsonDecode(cachedData);
//       final timestamp = decoded['timestamp'] as int;
//       final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
//
//       // Check if cache is still valid
//       if (cacheAge > _cacheValidity.inMilliseconds) {
//         return null;
//       }
//
//       final List<dynamic> ordersJson = decoded['data'];
//       return ordersJson.map((json) => Order.fromJson(json)).toList();
//     } catch (e) {
//       print('Error retrieving cached orders: $e');
//       return null;
//     }
//   }
//
//   static Future<void> clearCache(String deliveryId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove('$_ordersCachePrefix$deliveryId');
//     } catch (e) {
//       print('Error clearing cache: $e');
//     }
//   }
// }
//
// class OrderItem extends StatelessWidget {
//   final Order order;
//   final Function(Order) onTap;
//
//   const OrderItem({Key? key, required this.order, required this.onTap})
//     : super(key: key);
//
//   Color _getStatusColor() {
//     switch (order.status.toLowerCase()) {
//       case 'new':
//         return const Color(0xFF29D40F); // Green
//       case 'delivering':
//         return const Color(0xFF004F62); // Dark blue
//       case 'delivered':
//         return const Color(0xFF7F8C8D); // Gray
//       case 'returned':
//         return const Color(0xFFD42A0F); // Red
//       default:
//         return const Color(0xFF29D40F); // Default green
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final statusColor = _getStatusColor();
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 5,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         height: 91.h,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Order info section
//             Expanded(
//               child: Padding(
//                 padding:  EdgeInsets.only(left: 20.w,top: 8.h,
//                     ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       '#${order.billNumber}',
//                       style: TextStyle(
//                         color: Color(0xFF808080),
//                         fontSize: 12.sp,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       children: [
//                         // Status column
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Status',
//                                 style: TextStyle(
//                                   color: Color(0xFF808080),
//                                   fontSize: 10.sp,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 order.status,
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w600,
//                                   fontSize: 16.sp,
//                                   color: statusColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Divider
//                         Container(
//                           width: 1,
//                           height: 40,
//
//                           color: const Color(0xFFECECEC),
//                         ),
//                         // Price column
//                         Expanded(
//                           child: Padding(
//                             padding:  EdgeInsets.symmetric(
//                               horizontal: 7.w,
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Total price',
//                                   style: TextStyle(
//                                     color: Color(0xFF808080),
//                                     fontSize: 10.sp,
//                                   ),
//                                 ),
//                                 SizedBox(height: 4),
//                                 FittedBox(
//                                   child: Text(
//                                     '${order.totalAmount.toStringAsFixed(0)} LE',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16.sp,
//                                       color: Color(0xFF004F62),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         // Divider
//                         Container(
//                           width: 1,
//                           height: 40,
//                           margin: EdgeInsets.symmetric(horizontal: 7.w),
//                           color: const Color(0xFFECECEC),
//                         ),
//                         // Date column
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Date',
//                                 style: TextStyle(
//                                   color: Color(0xFF808080),
//                                   fontSize: 10.sp,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               FittedBox(
//                                 child: Text(
//                                   order.date,
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16.sp,
//                                     color: Color(0xFF004F62),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
// SizedBox(width: 8.w,)
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             // Order details button
//             Container(
//               // padding:  EdgeInsets.symmetric(horizontal: 8.w, vertical: 0.h),
//               decoration: BoxDecoration(
//                 color: statusColor,
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(10),
//                   bottomRight: Radius.circular(10),
//                 ),
//               ),
//               child: InkWell(
//                 onTap: () => onTap(order),
//                 borderRadius: const BorderRadius.only(
//                   topRight: Radius.circular(10),
//                   bottomRight: Radius.circular(10),
//                 ),
//                 child: SizedBox(
//                   width: 44.w,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(height: 36.h),
//                       Text(
//                         'Order Details',
//                         style: TextStyle(color: Colors.white, fontSize: 8.sp),
//                         textAlign: TextAlign.center,
//                       ),
//
//                       Icon(
//                         Icons.chevron_right,
//                         color: Colors.white,
//                         size: 20.sp,
//                       ),
//                       const SizedBox(height: 8),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // widgets/empty_state.dart
//
// class EmptyState extends StatelessWidget {
//   const EmptyState({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//            SizedBox(height: 24.h),
//           Container(
//             height: 183.h,
//             width: 224.w,
//             child: Image.asset(AppImages.ic_emptyorder),
//           ),
//            SizedBox(height: 20.h),
//            Text(
//             'No orders yet',
//             style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 10),
//           Padding(
//             padding:  EdgeInsets.symmetric(horizontal: 48.w),
//             child: Text(
//               'You don\'t have any orders in your history.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color:AppColors.black,
//                   fontWeight: FontWeight.w300,
//                   fontSize: 16.sp),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
