// main.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import 'core/constants/colors.dart';
import 'core/di/dependency_injection.dart';
import 'features/login/data/repository/AuthRepository.dart';
import 'features/login/presentation/manger/SessionManager.dart';
import 'features/login/presentation/manger/auth_cubit.dart';
import 'features/login/presentation/login_screen.dart';
import 'features/order/data/services/cache_service.dart';
import 'features/order/presentation/order_screen.dart';
import 'features/splash/splash.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  await DeliveryLocalDataSourceImpl.instance.database;

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Setup dependency injection
  await setupDependencies();

  // Run the app with localization support
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: MultiProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<AuthCubit>(),
            ),
          ],
          child: Builder(
            builder: (context) => ActivityAwareApp(
              sessionManager: getIt<SessionManager>(),
              child: ToastificationConfigProvider(
                config: const ToastificationConfig(
                  // margin: EdgeInsets.fromLTRB(0, 16, 0, 110),
                  alignment: Alignment.center,
                  itemWidth: 440,
                  animationDuration: Duration(milliseconds: 500),
                ),
                child: MaterialApp(
                  title: 'Onyx Delivery'.tr(),
                  navigatorKey: navigatorKey,
                  debugShowCheckedModeBanner: false,
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  theme: _buildAppTheme(),
                  initialRoute: '/splash',
                  routes: _buildAppRoutes(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      cardColor: AppColors.white,
      cardTheme: CardTheme(
        color: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColors.white,
          size: 24.sp,
        ),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
      ),
      useMaterial3: true,
      fontFamily: GoogleFonts.montserrat().fontFamily,
    );
  }

  Map<String, WidgetBuilder> _buildAppRoutes() {
    return {
      '/splash': (context) => SplashScreen(),
      '/login': (context) => const LoginScreen(),
      // '/language': (context) => const LanguageSelectionScreen(),
      '/home': (context) => const OrdersScreen(),
    };
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
  void initState() {
    super.initState();

    widget.sessionManager
      ..dispose()
      ..start();
  }

  @override
  void dispose() {
    widget.sessionManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => widget.sessionManager.resetSessionTimer(),
      child: widget.child,
    );
  }
}
