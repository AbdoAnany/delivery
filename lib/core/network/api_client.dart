import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../errors/exception.dart';

class ApiClient {
  final http.Client client;

  ApiClient({required this.client});

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await client.post(
        Uri.parse('${ApiConstants.baseUrl}$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      ).timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException(message: 'No internet connection');
    } on http.ClientException {
      throw NetworkException(message: 'Failed to connect to server');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final jsonResponse = json.decode(response.body);
        final result = jsonResponse['Result'];

        if (result != null && result['ErrNo'] != 0) {
          throw ServerException(message: result['ErrMsg'] ?? 'Server error');
        }

        return jsonResponse;
      case 400:
        throw ServerException(message: 'Bad request');
      case 401:
      case 403:
        throw ServerException(message: 'Unauthorized');
      case 404:
        throw ServerException(message: 'Not found');
      case 500:
      default:
        throw ServerException(message: 'Server error: ${response.statusCode}');
    }
  }
}