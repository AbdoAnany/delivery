import '../../../login/data/model/login_response.dart';
import '../../presentation/app.dart';
import '../models/delivery_bill.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/delivery_bill.dart';
import '../models/status_type.dart';
import '../models/return_reason.dart';
abstract class DeliveryRepository {
  Future<dynamic> login(String deliveryNo, String password, String langNo);
  Future<List<DeliveryBillModel>> getDeliveryBills(String deliveryNo, String langNo, {String? billSrl, String? processedFlag});
  Future<List<StatusTypeModel>> getStatusTypes(String langNo);
  Future<List<ReturnReasonModel>> getReturnReasons(String langNo);
  Future<bool> updateBillStatus(String billSrl, String statusFlag, String returnReason, String langNo);
}

class DeliveryRepositoryImpl implements DeliveryRepository {
  final DeliveryRemoteDataSource remoteDataSource;
  final DeliveryLocalDataSource localDataSource;
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
  Future<LoginResponse> login(String deliveryNo, String password, String langNo) async {
    if (await _isConnected()) {
      try {
        final remoteUser = await remoteDataSource.login(deliveryNo, password, langNo);
        await localDataSource.cacheUser(remoteUser);
        return remoteUser;
      } catch (e) {
        throw Exception('Failed to login: ${e.toString()}');
      }
    } else {
      try {
        return await localDataSource.getLastLoggedInUser();
      } catch (e) {
        throw Exception('No internet connection and no cached user');
      }
    }
  }

  @override
  Future<List<DeliveryBillModel>> getDeliveryBills(String deliveryNo, String langNo, {String? billSrl, String? processedFlag}) async {
    if (await _isConnected()) {
      try {
        final remoteBills = await remoteDataSource.getDeliveryBills(
            deliveryNo, langNo, billSrl: billSrl, processedFlag: processedFlag
        );
        await localDataSource.cacheBills(remoteBills);
        return remoteBills;
      } catch (e) {
        try {
          return await localDataSource.getCachedBills();
        } catch (cacheError) {
          throw Exception('Failed to get delivery bills: ${e.toString()}');
        }
      }
    } else {
      try {
        return await localDataSource.getCachedBills();
      } catch (e) {
        throw Exception('No internet connection and no cached bills');
      }
    }
  }

  @override
  Future<List<StatusTypeModel>> getStatusTypes(String langNo) async {
    if (await _isConnected()) {
      try {
        final remoteTypes = await remoteDataSource.getStatusTypes(langNo);
        await localDataSource.cacheStatusTypes(remoteTypes);
        return remoteTypes;
      } catch (e) {
        try {
          return await localDataSource.getCachedStatusTypes();
        } catch (cacheError) {
          throw Exception('Failed to get status types: ${e.toString()}');
        }
      }
    } else {
      try {
        return await localDataSource.getCachedStatusTypes();
      } catch (e) {
        throw Exception('No internet connection and no cached status types');
      }
    }
  }

  @override
  Future<List<ReturnReasonModel>> getReturnReasons(String langNo) async {
    if (await _isConnected()) {
      try {
        final remoteReasons = await remoteDataSource.getReturnReasons(langNo);
        await localDataSource.cacheReturnReasons(remoteReasons);
        return remoteReasons;
      } catch (e) {
        try {
          return await localDataSource.getCachedReturnReasons();
        } catch (cacheError) {
          throw Exception('Failed to get return reasons: ${e.toString()}');
        }
      }
    } else {
      try {
        return await localDataSource.getCachedReturnReasons();
      } catch (e) {
        throw Exception('No internet connection and no cached return reasons');
      }
    }
  }

  @override
  Future<bool> updateBillStatus(String billSrl, String statusFlag, String returnReason, String langNo) async {
    if (await _isConnected()) {
      try {
        return await remoteDataSource.updateBillStatus(billSrl, statusFlag, returnReason, langNo);
      } catch (e) {
        throw Exception('Failed to update bill status: ${e.toString()}');
      }
    } else {
      throw Exception('No internet connection. Cannot update bill status');
    }
  }
}
