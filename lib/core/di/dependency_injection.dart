// core/di/dependency_injection.dart
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/login/data/datasources/local/AuthLocalDataSource.dart';
import '../../features/login/data/datasources/remote/AuthRemoteDataSource.dart';
import '../../features/login/data/datasources/remote/api_service.dart';
import '../../features/login/data/repository/AuthRepository.dart';
import '../../features/login/presentation/manger/SessionManager.dart';
import '../../features/login/presentation/manger/auth_cubit.dart';
import '../../features/order/data/repositories/order_repository.dart';
import '../../features/order/data/services/api_service.dart';
import '../../features/order/data/services/cache_service.dart';
import '../../core/network/api_client.dart';
import '../../features/order/presentation/manger/orders_cubit.dart';
import '../../main.dart';

// Create GetIt instance
final getIt = GetIt.instance;

/// Sets up all dependencies for the application
Future<void> setupDependencies() async {
  // Register singletons
  await _registerCoreServices();
  await _registerDataSources();
  await _registerRepositories();
  await _registerManagers();
  await _registerCubits();
  await _ordersCubit();
}

/// Register core services like shared preferences, http client, etc.
Future<void> _registerCoreServices() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final httpClient = http.Client();
  final connectivity = Connectivity();

  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<http.Client>(httpClient);
  getIt.registerSingleton<Connectivity>(connectivity);
  getIt.registerSingleton<ApiClient>(ApiClient(client: getIt<http.Client>()));
}

/// Register data sources
Future<void> _registerDataSources() async {
  // Auth data sources
  getIt.registerSingleton<AuthLocalDataSource>(AuthLocalDataSource());
  getIt.registerSingleton<AuthRemoteDataSource>(AuthRemoteDataSource());
  // getIt.registerSingleton<ApiService>(ApiService(client: getIt<http.Client>()));

  // Delivery data sources
  getIt.registerSingleton<DeliveryRemoteDataSourceImpl>(
      DeliveryRemoteDataSourceImpl(apiClient: getIt<ApiClient>())
  );
  getIt.registerSingleton<DeliveryLocalDataSourceImpl>(
      DeliveryLocalDataSourceImpl.instance
  );
}

/// Register repositories
Future<void> _registerRepositories() async {
  // Auth repository
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );

  // Delivery repository
  getIt.registerSingleton<DeliveryRepositoryImpl>(
    DeliveryRepositoryImpl(
      remoteDataSource: getIt<DeliveryRemoteDataSourceImpl>(),
      localDataSource: getIt<DeliveryLocalDataSourceImpl>(),
      connectivity: getIt<Connectivity>(),
    ),
  );
}

/// Register managers
Future<void> _registerManagers() async {
  getIt.registerLazySingleton<SessionManager>(() => SessionManager(
    onSessionExpired: () {
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
    },
  ));}

/// Register providers
// Future<void> _registerProviders() async {
//   getIt.registerSingleton<AuthProvider>(
//     AuthProvider(
//       authRepository  : getIt<AuthRepository>(),
//       sharedPreferences: getIt<SharedPreferences>(),
//     ),
//   );
// }

/// Register BLoC cubits
Future<void> _registerCubits() async {
  getIt.registerSingleton<AuthCubit>(
    AuthCubit(
      sharedPreferences: getIt<SharedPreferences>(),
      authRepository: getIt<AuthRepository>(),
      sessionManager: getIt<SessionManager>(),
    ),
  );
}Future<void> _ordersCubit() async {
  getIt.registerSingleton<OrdersCubit>(
    OrdersCubit(
   deliveryRepository: getIt<DeliveryRepositoryImpl>(),
    ),
  );
}