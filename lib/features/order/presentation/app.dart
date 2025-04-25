// I'll help you create a Flutter application that handles both local data and API calls for this delivery service. Based on the API endpoints you've provided, I'll implement a repository pattern to manage data fetching, error handling, and language support (P_LANG_NO 1 or 2).
//
// Let's start by setting up the project structure:
//
// ```dart
// Project Structure:
// lib/
// ├── main.dart
// ├── core/
// │   ├── constants/
// │   │   └── api_constants.dart
// │   ├── errors/
// │   │   └── exceptions.dart
// │   ├── network/
// │   │   └── api_client.dart
// │   └── utils/
// │       └── language_util.dart
// ├── data/
// │   ├── datasources/
// │   │   ├── local/
// │   │   │   └── delivery_local_datasource.dart
// │   │   └── remote/
// │   │       └── delivery_remote_datasource.dart
// │   ├── models/
// │   │   ├── login_response.dart
// │   │   ├── delivery_bill.dart
// │   │   ├── status_type.dart
// │   │   └── return_reason.dart
// │   └── repositories/
// │       └── delivery_repository_impl.dart
// ├── domain/
// │   ├── entities/
// │   │   ├── delivery_user.dart
// │   │   ├── bill.dart
// │   │   ├── status_type.dart
// │   │   └── return_reason.dart
// │   ├── repositories/
// │   │   └── delivery_repository.dart
// │   └── usecases/
// │       ├── login_usecase.dart
// │       ├── get_bills_usecase.dart
// │       ├── get_status_types_usecase.dart
// │       ├── get_return_reasons_usecase.dart
// │       └── update_bill_status_usecase.dart
// └── presentation/
//     ├── bloc/
//     │   ├── auth/
//     │   │   ├── auth_bloc.dart
//     │   │   ├── auth_event.dart
//     │   │   └── auth_state.dart
//     │   ├── bills/
//     │   │   ├── bills_bloc.dart
//     │   │   ├── bills_event.dart
//     │   │   └── bills_state.dart
//     │   └── status/
//     │       ├── status_bloc.dart
//     │       ├── status_event.dart
//     │       └── status_state.dart
//     ├── screens/
//     │   ├── login_screen.dart
//     │   ├── bills_screen.dart
//     │   └── bill_detail_screen.dart
//     └── widgets/
//         ├── bill_card.dart
//         └── status_dropdown.dart

// Let's start implementing key components:

// 1. First, let's set up API constants
// lib/core/constants/api_constants.dart

// 2. Custom exceptions
// lib/core/errors/exceptions.dart


// 3. API Client
// lib/core/network/api_client.dart


// 4. Language Utility
// lib/core/utils/language_util.dart

// 5. Models
// lib/data/models/login_response.dart

// lib/data/models/delivery_bill.dart

// lib/data/models/status_type.dart


// lib/data/models/return_reason.dart


// 6. Remote Data Source
// lib/data/datasources/remote/delivery_remote_datasource.dart

// 7. Local Data Source
// lib/data/datasources/local/delivery_local_datasource.dart

// 8. Repository Implementation
// lib/data/repositories/delivery_repository_impl.dart

// 9. Domain Repository Interface
// lib/domain/repositories/delivery_repository.dart

// 10. Simple UI Implementation
// lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:http/http.dart' as http;
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'core/network/api_client.dart';
// import 'data/datasources/local/delivery_local_datasource.dart';
// import 'data/datasources/remote/delivery_remote_datasource.dart';
// import 'data/repositories/delivery_repository_impl.dart';
// import 'presentation/screens/login_screen.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   final sharedPreferences = await SharedPreferences.getInstance();
//   final httpClient = http.Client();
//   final apiClient = ApiClient(client: httpClient);
//   final remoteDataSource = DeliveryRemoteDataSourceImpl(apiClient: apiClient);
//   final localDataSource = DeliveryLocalDataSourceImpl(sharedPreferences: sharedPreferences);
//   final connectivity = Connectivity();
//   final repository = DeliveryRepositoryImpl(
//     remoteDataSource: remoteDataSource,
//     localDataSource: localDataSource,
//     connectivity: connectivity,
//   );
//
//   runApp(DeliveryApp(repository: repository));
// }
//
// class DeliveryApp extends StatelessWidget {
//   final DeliveryRepositoryImpl repository;
//
//   const DeliveryApp({Key? key, required this.repository}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Delivery App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: LoginScreen(repository: repository),
//     );
//   }
// }
//
// // lib/presentation/screens/login_screen.dart
// import 'package:flutter/material.dart';
// import '../../data/repositories/delivery_repository_impl.dart';
// import '../../core/utils/language_util.dart';
// import 'bills_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   final DeliveryRepositoryImpl repository;
//
//   const LoginScreen({Key? key, required this.repository}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _deliveryNoController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   @override
//   void dispose() {
//     _deliveryNoController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true;
//         _errorMessage = null;
//       });
//
//       try {
//         final user = await widget.repository.login(
//           _deliveryNoController.text,
//           _passwordController.text,
//           LanguageUtil.getCurrentLanguage(),
//         );
//
//         if (mounted) {
//           Navigator.of(context).pushReplacement(
//             MaterialPageRoute(
//               builder: (context) => BillsScreen(
//                 repository: widget.repository,
//                 deliveryNo: _deliveryNoController.text,
//                 deliveryName: user.deliveryName,
//               ),
//             ),
//           );
//         }
//       } catch (e) {
//         setState(() {
//           _errorMessage = e.toString();
//         });
//       } finally {
//         if (mounted) {
//           setState(() {
//             _isLoading = false;
//           });
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Login'),
//         ),
//         body: Padding(
//         padding: const EdgeInsets.all(16.0),
//     child: Form(
//     key: _formKey,
//     child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//     TextFormField(
//     controller: _deliveryNoController,
//     decoration: const InputDecoration(
//     labelText: 'Delivery Number',
//     border: OutlineInputBorder(),
//     ),
//     keyboardType: TextInputType.number,
//     validator: (value) {
//     if (value == null || value.isEmpty) {
//     return 'Please enter delivery number';
//     }
//     return null;
//     },
//     ),
//     const SizedBox(height: 16),
//     TextFormField(
//     controller: _passwordController,
//     decoration: const InputDecoration(
//     labelText: 'Password',
//     border: OutlineInputBorder(),
//     ),
//     obscureText: true,
//     validator: (value) {
//     if (value == null || value.isEmpty) {
//     return 'Please enter password';
//     }
//     return null;
//     },
//     ),
//     const SizedBox(height: 24),
//     if (_errorMessage != null)
//     Padding(
//     padding: const EdgeInsets.only(bottom
//     ```

//
// padding: const EdgeInsets.only(bottom: 16),
// child: Text(
// _errorMessage!,
// style: const TextStyle(color: Colors.red),
// ),
// ),
// _isLoading
// ? const CircularProgressIndicator()
//     : ElevatedButton(
// onPressed: _login,
// style: ElevatedButton.styleFrom(
// minimumSize: const Size.fromHeight(50),
// ),
// child: const Text('Login'),
// ),
// ],
// ),
// ),
// ),
// );
// }
// }
//
// // lib/presentation/screens/bills_screen.dart
// import 'package:flutter/material.dart';
// import '../../data/repositories/delivery_repository_impl.dart';
// import '../../core/utils/language_util.dart';
// import '../../data/models/delivery_bill.dart';
// import '../widgets/bill_card.dart';
// import 'bill_detail_screen.dart';
//
// class BillsScreen extends StatefulWidget {
// final DeliveryRepositoryImpl repository;
// final String deliveryNo;
// final String deliveryName;
//
// const BillsScreen({
// Key? key,
// required this.repository,
// required this.deliveryNo,
// required this.deliveryName,
// }) : super(key: key);
//
// @override
// _BillsScreenState createState() => _BillsScreenState();
// }
//
// class _BillsScreenState extends State<BillsScreen> {
// List<DeliveryBillModel> _bills = [];
// bool _isLoading = false;
// String? _errorMessage;
//
// @override
// void initState() {
// super.initState();
// _loadBills();
// }
//
// Future<void> _loadBills() async {
// setState(() {
// _isLoading = true;
// _errorMessage = null;
// });
//
// try {
// final bills = await widget.repository.getDeliveryBills(
// widget.deliveryNo,
// LanguageUtil.getCurrentLanguage(),
// );
//
// setState(() {
// _bills = bills;
// });
// } catch (e) {
// setState(() {
// _errorMessage = e.toString();
// });
// } finally {
// setState(() {
// _isLoading = false;
// });
// }
// }
//
// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(
// title: const Text('Delivery Bills'),
// ),
// body: RefreshIndicator(
// onRefresh: _loadBills,
// child: _isLoading
// ? const Center(child: CircularProgressIndicator())
//     : _errorMessage != null
// ? Center(
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text(
// _errorMessage!,
// style: const TextStyle(color: Colors.red),
// textAlign: TextAlign.center,
// ),
// const SizedBox(height: 16),
// ElevatedButton(
// onPressed: _loadBills,
// child: const Text('Retry'),
// ),
// ],
// ),
// )
//     : _bills.isEmpty
// ? const Center(child: Text('No bills found'))
//     : ListView.builder(
// itemCount: _bills.length,
// padding: const EdgeInsets.all(8),
// itemBuilder: (context, index) {
// final bill = _bills[index];
// return BillCard(
// bill: bill,
// onTap: () {
// Navigator.of(context).push(
// MaterialPageRoute(
// builder: (context) => BillDetailScreen(
// repository: widget.repository,
// bill: bill,
// ),
// ),
// ).then((_) => _loadBills());
// },
// );
// },
// ),
// ),
// bottomNavigationBar: Container(
// padding: const EdgeInsets.all(16),
// color: Colors.blue[50],
// child: Text(
// 'Delivery Officer: ${widget.deliveryName}',
// style: const TextStyle(
// fontWeight: FontWeight.bold,
// ),
// textAlign: TextAlign.center,
// ),
// ),
// );
// }
// }
//
// // lib/presentation/widgets/bill_card.dart
// import 'package:flutter/material.dart';
// import '../../data/models/delivery_bill.dart';
//
// class BillCard extends StatelessWidget {
// final DeliveryBillModel bill;
// final VoidCallback onTap;
//
// const BillCard({
// Key? key,
// required this.bill,
// required this.onTap,
// }) : super(key: key);
//
// String _getStatusText(String statusFlag) {
// switch (statusFlag) {
// case '0':
// return 'Pending';
// case '1':
// return 'Delivered';
// case '2':
// return 'Partial Return';
// case '3':
// return 'Full Return';
// default:
// return 'Unknown';
// }
// }
//
// Color _getStatusColor(String statusFlag) {
// switch (statusFlag) {
// case '0':
// return Colors.orange;
// case '1':
// return Colors.green;
// case '2':
// return Colors.amber;
// case '3':
// return Colors.red;
// default:
// return Colors.grey;
// }
// }
//
// @override
// Widget build(BuildContext context) {
// return Card(
// margin: const EdgeInsets.symmetric(vertical: 8),
// elevation: 2,
// child: InkWell(
// onTap: onTap,
// child: Padding(
// padding: const EdgeInsets.all(16),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// 'Bill #${bill.billNo}',
// style: const TextStyle(
// fontWeight: FontWeight.bold,
// fontSize: 16,
// ),
// ),
// Chip(
// label: Text(
// _getStatusText(bill.dlvryStatusFlg),
// style: const TextStyle(
// color: Colors.white,
// fontSize: 12,
// ),
// ),
// backgroundColor: _getStatusColor(bill.dlvryStatusFlg),
// ),
// ],
// ),
// const SizedBox(height: 8),
// Text('Customer: ${bill.cstmrNm}'),
// const SizedBox(height: 4),
// Text('Date: ${bill.billDate} at ${bill.billTime}'),
// const SizedBox(height: 4),
// Text('Region: ${bill.rgnNm.isNotEmpty ? bill.rgnNm : "N/A"}'),
// const SizedBox(height: 8),
// Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Text(
// 'Mobile: ${bill.mobileNo.isNotEmpty ? bill.mobileNo : "N/A"}',
// style: const TextStyle(fontSize: 13),
// ),
// Text(
// 'Amount: ${bill.billAmt}',
// style: const TextStyle(
// fontWeight: FontWeight.bold,
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// ),
// );
// }
// }