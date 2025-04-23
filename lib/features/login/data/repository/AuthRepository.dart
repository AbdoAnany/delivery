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
      
      print('Login response: $response');

      // Check for successful login based on response
      if (response['Result']['ErrNo'] == 0) {
        // Extract user data from response
        final userData = response['Data'];
        final user = User(
          deliveryNo: deliveryNo,
          languageNo: languageNo,
          name: userData['DeliveryName'] ?? 'Delivery User',

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