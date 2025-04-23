// auth_repository.dart

import '../datasources/local/AuthLocalDataSource.dart';
import '../datasources/remote/AuthRemoteDataSource.dart';
import '../model/User.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepository({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  Future<User?> login({
    required String deliveryNo,
    required String password,
    required String languageNo,
  }) async {
    try {
      final response = await _remoteDataSource.checkDeliveryLogin(
        deliveryNo: deliveryNo,
        password: password,
        languageNo: languageNo,
      );

      // Check for successful login based on response
      if (response['Result'] == true) {
        // Extract user data from response
        final userData = response['Data'][0];
        final user = User(
          deliveryNo: deliveryNo,
          languageNo: languageNo,
          name: userData['DLVRY_NM'] ?? 'Delivery User',
          token: userData['TOKEN'] ?? '',
        );

        // Save user to local storage
        await _localDataSource.saveUser(user);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _localDataSource.clearUser();
  }

  Future<User?> getLoggedInUser() async {
    return await _localDataSource.getUser();
  }
}