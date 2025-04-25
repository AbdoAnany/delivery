// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/AppColor.dart';
import 'features/login/data/datasources/local/AuthLocalDataSource.dart';
import 'features/login/data/datasources/remote/AuthRemoteDataSource.dart';
import 'features/login/data/repository/AuthRepository.dart';
import 'features/login/presentation/HomeScreen.dart';
import 'features/login/presentation/login_screen.dart';
import 'features/login/presentation/manger/SessionManager.dart';
import 'features/login/presentation/manger/auth_cubit.dart';
import 'features/splash/splash.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {

        return MediaQuery(
            data: MediaQuery.of(context).copyWith(
          textScaleFactor: 1.0, // Fixed scale factor
        ),

            child: MultiRepositoryProvider(
            providers: [
              RepositoryProvider(create: (context) => AuthRemoteDataSource()),
              RepositoryProvider(create: (context) => AuthLocalDataSource()),
              RepositoryProvider(create: (context) => SessionManager()),
              RepositoryProvider(
                create: (context) => AuthRepository(
                  remoteDataSource: context.read(),
                  localDataSource: context.read(),
                ),
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => AuthCubit(
                    authRepository: context.read(),
                    sessionManager: context.read(),
                  ),
                ),
              ],
              child: Builder(
                builder: (context) {
                  return ActivityAwareApp(
                    sessionManager: context.read<SessionManager>(),
                    child: MaterialApp(
                      title: 'Onyx Delivery',
                      debugShowCheckedModeBanner: false,
                      theme: ThemeData(
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: AppColors.primary,
                          primary: AppColors.primary,
                        ),
                        useMaterial3: true,
                        fontFamily: 'Montserrat',
                      ),
                      initialRoute: '/splash',
                      routes: {
                        '/splash': (context) =>  SplashScreen(),
                        '/login': (context) => const LoginScreen(),
                        '/home': (context) => const OrdersScreen(),
                      },
                    ),
                  );
                },
              ),
            ),
                    ),
          );
      },
    );
  }
}
class ActivityAwareApp extends StatefulWidget {
  final Widget child;
  final SessionManager sessionManager;

  const ActivityAwareApp({
    super.key,
    required this.child,
    required this.sessionManager,
  });

  @override
  State<ActivityAwareApp> createState() => _ActivityAwareAppState();
}

class _ActivityAwareAppState extends State<ActivityAwareApp> {
  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        widget.sessionManager.userActivity();
      },
      child: widget.child,
    );
  }
}