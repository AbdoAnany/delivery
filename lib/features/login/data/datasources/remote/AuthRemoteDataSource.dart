// auth_remote_datasource.dart
import 'package:dio/dio.dart';

import '../../../../../core/AppColor.dart';

class AuthRemoteDataSource {
  late final Dio _dio;

  AuthRemoteDataSource() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
      ),
    );

    // Add logging interceptor for debug mode
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<Map<String, dynamic>> checkDeliveryLogin({
    required String deliveryNo,
    required String password,
    required String languageNo,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {
          "Value": {
            "P_LANG_NO": languageNo,
            "P_DLVRY_NO": deliveryNo,
            "P_PSSWRD": password
          }
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Login failed with status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Connection timeout. Please check your internet connection.';
      } else if (e.response != null) {
        final errorMessage = e.response?.data?['ErrorMessage'] ?? 'Unknown error occurred';
        throw errorMessage;
      } else {
        throw 'Connection error: ${e.message}';
      }
    } catch (e) {
      throw 'Login failed: $e';
    }
  }

  Future<Map<String, dynamic>> getDeliveryBills({
    required String deliveryNo,
    required String languageNo,
    String billSerial = '',
    String processedFlag = '',
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.deliveryBillsEndpoint,
        data: {
          "Value": {
            "P_DLVRY_NO": deliveryNo,
            "P_LANG_NO": languageNo,
            "P_BILL_SRL": billSerial,
            "P_PRCSSD_FLG": processedFlag
          }
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to get delivery bills with status code: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw 'Connection timeout. Please check your internet connection.';
      } else if (e.response != null) {
        final errorMessage = e.response?.data?['ErrorMessage'] ?? 'Unknown error occurred';
        throw errorMessage;
      } else {
        throw 'Connection error: ${e.message}';
      }
    } catch (e) {
      throw 'Failed to get delivery bills: $e';
    }
  }

  Future<Map<String, dynamic>> getDeliveryStatusTypes({
    required String languageNo,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.deliveryStatusTypesEndpoint,
        data: {
          "Value": {
            "P_LANG_NO": languageNo
          }
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to get status types with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw 'Failed to get delivery status types: $e';
    }
  }

  Future<Map<String, dynamic>> getReturnBillReasons({
    required String languageNo,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.returnBillReasonsEndpoint,
        data: {
          "Value": {
            "P_LANG_NO": languageNo
          }
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to get return bill reasons with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw 'Failed to get return bill reasons: $e';
    }
  }

  Future<Map<String, dynamic>> updateDeliveryBillStatus({
    required String languageNo,
    required String billSerial,
    required String deliveryStatusFlag, 
    String returnReason = '',
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.updateDeliveryBillStatusEndpoint,
        data: {
          "Value": {
            "P_LANG_NO": languageNo,
            "P_BILL_SRL": billSerial,
            "P_DLVRY_STATUS_FLG": deliveryStatusFlag,
            "P_DLVRY_RTRN_RSN": returnReason
          }
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to update bill status with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw 'Failed to update delivery bill status: $e';
    }
  }

  Future<Map<String, dynamic>> changeDeliveryPassword({
    required String languageNo,
    required String deliveryNo,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post(
        '/ChangeDeliveryPassword',
        data: {
          "Value": {
            "P_LANG_NO": languageNo,
            "P_DLVRY_NO": deliveryNo,
            "P_OLD_PSSWRD": oldPassword,
            "P_NEW_PSSWRD": newPassword
          }
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Failed to change password with status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw 'Failed to change password: $e';
    }
  }
}