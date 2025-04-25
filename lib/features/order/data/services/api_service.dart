import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../../../login/data/model/login_response.dart';
import '../models/delivery_bill.dart';
import '../models/return_reason.dart';
import '../models/status_type.dart';



abstract class DeliveryRemoteDataSource {
  Future<List<DeliveryBillModel>> getDeliveryBills(String deliveryNo, String langNo, {String? billSrl, String? processedFlag});
  Future<List<StatusTypeModel>> getStatusTypes(String langNo);
  Future<List<ReturnReasonModel>> getReturnReasons(String langNo);
  Future<bool> updateBillStatus(String billSrl, String statusFlag, String returnReason, String langNo);
}

class DeliveryRemoteDataSourceImpl implements DeliveryRemoteDataSource {
  final ApiClient apiClient;

  DeliveryRemoteDataSourceImpl({required this.apiClient});


  @override
  Future<List<DeliveryBillModel>> getDeliveryBills(String deliveryNo, String langNo, {String? billSrl, String? processedFlag}) async {
    final body = {
      "Value": {
        "P_DLVRY_NO": deliveryNo,
        "P_LANG_NO": langNo,
        "P_BILL_SRL": billSrl ?? "",
        "P_PRCSSD_FLG": processedFlag ?? ""
      }
    };

    final response = await apiClient.post(ApiConstants.deliveryBillsEndpoint, body);
    final bills = response['Data']['DeliveryBills'] as List;
    return bills.map((bill) => DeliveryBillModel.fromJson(bill)).toList();
  }

  @override
  Future<List<StatusTypeModel>> getStatusTypes(String langNo) async {
    final body = {
      "Value": {
        "P_LANG_NO": langNo
      }
    };

    final response = await apiClient.post(ApiConstants.deliveryStatusTypesEndpoint, body);
    final types = response['Data']['DeliveryStatusTypes'] as List;
    return types.map((type) => StatusTypeModel.fromJson(type)).toList();
  }

  @override
  Future<List<ReturnReasonModel>> getReturnReasons(String langNo) async {
    final body = {
      "Value": {
        "P_LANG_NO": langNo
      }
    };

    final response = await apiClient.post(ApiConstants.returnBillReasonsEndpoint, body);
    final reasons = response['Data']['ReturnBillReasons'] as List;
    return reasons.map((reason) => ReturnReasonModel.fromJson(reason)).toList();
  }

  @override
  Future<bool> updateBillStatus(String billSrl, String statusFlag, String returnReason, String langNo) async {
    final body = {
      "Value": {
        "P_LANG_NO": langNo,
        "P_BILL_SRL": billSrl,
        "P_DLVRY_STATUS_FLG": statusFlag,
        "P_DLVRY_RTRN_RSN": returnReason
      }
    };

    final response = await apiClient.post(ApiConstants.updateDeliveryBillStatusEndpoint, body);
    return response['Result']['ErrNo'] == 0;
  }
}
