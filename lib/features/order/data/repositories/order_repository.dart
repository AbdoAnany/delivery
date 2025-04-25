import 'package:delivery/core/utils/Global.dart';

import '../../../login/data/model/login_response.dart';
import '../models/delivery_bill.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/status_type.dart';
import '../models/return_reason.dart';

abstract class DeliveryRepository {
  Future<List<DeliveryBillModel>> getDeliveryBills(
      String deliveryNo,
      String langNo, {
        String? billSrl,
        String? processedFlag,
      });
  Future<List<DeliveryBillModel>> getFilteredDeliveryBills(
     {
       String? statusFilter,
       String? dateFilter,
       String? searchQuery,
      });

  Future<List<StatusTypeModel>> getStatusTypes(String langNo);
  Future<List<ReturnReasonModel>> getReturnReasons(String langNo);
  Future<bool> updateBillStatus(
      String billSrl,
      String statusFlag,
      String returnReason,
      String langNo,
      );
  Future<void> clearDeliveryData();
}

class DeliveryRepositoryImpl implements DeliveryRepository {
  final DeliveryRemoteDataSource remoteDataSource;
  final DeliveryLocalDataSourceImpl localDataSource;
  final Connectivity connectivity;

  DeliveryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivity,
  });

  Future<bool> _isConnected() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Future<List<DeliveryBillModel>> getDeliveryBills(
      String deliveryNo,
      String langNo, {
        String? billSrl,
        String? processedFlag,
      }) async {
    print('Fetching bills');
    final bills = await localDataSource.getBills().catchError((e) => print('Error fetching bills from local: $e'));
    if (bills.isNotEmpty) {
      print('Using  cached bills ${bills.length}');
      return bills;
    }else {
      if (await _isConnected()) {

        try {
          final remoteBills = await remoteDataSource.getDeliveryBills(
            deliveryNo,
            langNo,
            billSrl: billSrl,
            // processedFlag: processedFlag,
          );
          print('Fetched ${remoteBills.length} bills from remote');
          await localDataSource.insertOrUpdateBills(remoteBills.map((bill) => bill.toJson()).toList());
          print('Inserted ${remoteBills.length} bills into local');
          return remoteBills;
        } catch (e) {
          // Fallback to local
          return await localDataSource.getBills();
        }
      } else {
        return await localDataSource.getBills();
      }
    }
  }

  @override
  Future<List<StatusTypeModel>> getStatusTypes(String langNo) async {
    if (await _isConnected()) {
      try {
        final remoteTypes = await remoteDataSource.getStatusTypes(langNo);
        await localDataSource.insertStatusTypes(remoteTypes, langNo);
        return remoteTypes;
      } catch (e) {
        return    await localDataSource.getStatusTypes(Global.user!.languageNo);
      }
    } else {
      return    await localDataSource.getStatusTypes(Global.user!.languageNo);
    }
  }

  @override
  Future<List<ReturnReasonModel>> getReturnReasons(String langNo) async {
    if (await _isConnected()) {
      try {
        final remoteReasons = await remoteDataSource.getReturnReasons(langNo);
        await localDataSource.insertReturnReasons(remoteReasons, langNo);
        return remoteReasons;
      } catch (e) {
        return await localDataSource.getReturnReasons(langNo);
      }
    } else {
      return await localDataSource.getReturnReasons(langNo);
    }
  }

  @override
  Future<bool> updateBillStatus(
      String billSrl,
      String statusFlag,
      String returnReason,
      String langNo,
      ) async {
    if (await _isConnected()) {
      try {
        return await remoteDataSource.updateBillStatus(
          billSrl,
          statusFlag,
          returnReason,
          langNo,
        );
      } catch (e) {
        throw Exception('Failed to update bill status: ${e.toString()}');
      }
    } else {
      throw Exception('No internet connection. Cannot update bill status');
    }
  }
  //
  // @override
  // Future<List<DeliveryBillModel>> getFilteredDeliveryBills(
  //     String deliveryNo,
  //     String langNo, {
  //       String? billSrl,
  //       String? processedFlag,
  //       String? statusFilter,
  //       String? dateFilter,
  //       String? searchQuery,
  //     }) async {
  //   try {
  //     // First ensure we have data in the local database
  //     final localBills = await localDataSource.getBills();
  //
  //     // If local database is empty and we're connected, fetch from remote and save
  //     if (localBills.isEmpty && await _isConnected()) {
  //       final remoteBills = await remoteDataSource.getDeliveryBills(
  //         deliveryNo,
  //         langNo,
  //         billSrl: "",
  //         processedFlag: "",
  //       );
  //       await localDataSource.insertOrUpdateBills(remoteBills.map((bill) => bill.toJson()).toList());
  //     }
  //
  //     // Now perform the filtered query from local database
  //     return await localDataSource.getFilteredBills(
  //       statusFilter: statusFilter,
  //       dateFilter: dateFilter,
  //       searchQuery: searchQuery,
  //     );
  //   } catch (e) {
  //     print('Error getting filtered bills: $e');
  //     // Return empty list on error
  //     return [];
  //   }
  // }



  // Fetch data from server and store locally

  // Get all orders (for statistics)
  Future<List<DeliveryBillModel>> getAllDeliveryBills() async {
    return await localDataSource.getBills();
  }

  // Get filtered orders using SQL
  Future<List<DeliveryBillModel>> getFilteredDeliveryBills({
    String? statusFilter,
    String? dateFilter,
    String? searchQuery,
  }) async {
    // Convert dateFilter to actual date format for SQL
    String? formattedDateFilter;
    if (dateFilter != null) {
      final now = DateTime.now();
      switch (dateFilter) {
        case 'today':
          formattedDateFilter = _formatDate(now);
          break;
        case 'this_week':
          final startOfWeek = now.subtract(Duration(days: now.weekday));
        // We'll handle this in SQL
        formattedDateFilter = _formatDate(startOfWeek);
          break;
        case 'this_month':
          final startOfMonth = DateTime(now.year, now.month, 1);
          formattedDateFilter = _formatDate(startOfMonth);
          break;
        // We'll handle this in SQL
          break;
      }
    }

    return await localDataSource.getFilteredBills(
      statusFilter: statusFilter,
      dateFilter: dateFilter,  // Pass the filter type, not formatted date
      searchQuery: searchQuery,
    );
  }

  String _formatDate(DateTime date) {
    // Format date according to your database format (DD/MM/YYYY)
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }





  Future<void> clearDeliveryData() async {
    await localDataSource.clearDeliveryData();
  }
}

