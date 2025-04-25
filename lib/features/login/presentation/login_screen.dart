// login_screen.dart
import 'package:delivery/core/di/dependency_injection.dart';
import 'package:delivery/features/login/presentation/widget/CustomTextField.dart';
import 'package:delivery/features/login/presentation/widget/LanguageSelector.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:delivery/core/constants/colors.dart';


import '../../../core/constants/image.dart';
import '../../../core/utils/app_toast.dart';
import 'manger/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deliveryNoController = TextEditingController(text: '1010');
  final _passwordController = TextEditingController(text: '1');

  @override
  void dispose() {
    _deliveryNoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
      deliveryNo: _deliveryNoController.text,
      password: _passwordController.text,
      languageNo: getIt<AuthCubit>().languageNo, context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,

      resizeToAvoidBottomInset: true,


      appBar: AppBar(
        backgroundColor: AppColors.background,

        flexibleSpace:   _buildHeader(),
          toolbarHeight: 100.h,
      ),
      backgroundColor:  AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            AppToast.error(context: context, message: 'An error occurred: ${state.message.toString()}');

          } else if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child:  Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // App logo and language selector area


                     SizedBox(height: 232.h),

                    // Welcome message
                    Center(
                      child: Text(
                        'Welcome Back!'.tr(),
                        style: TextStyle(
                          fontSize: 29.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                     SizedBox(height: 12.h),

                    Center(
                      child: Text(
                        'Log back into your account'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                     SizedBox(height: 44.h),

                    // User ID field
                    CustomTextField(
                      controller: _deliveryNoController,
                      hintText: 'User ID',
                      validator: (value) => value?.isEmpty ?? true
                          ? 'User ID is required'
                          : null,
                    ),

                     SizedBox(height: 8.h),

                    // Password field
                    CustomTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      // obscureText: !_passwordVisible,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Password is required'
                          : null,
                      // suffixIcon: GestureDetector(
                      //   onTap: () {
                      //     setState(() {
                      //       _passwordVisible = !_passwordVisible;
                      //     });
                      //   },
                      //
                      // ),
                    ),

                     SizedBox(height: 27.h),
                 Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                      'Show More'.tr(),
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                     SizedBox(height: 24.h),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 44.h,
                      child: CustomButton(
                        text: 'Login'.tr(),
                        isLoading: state is AuthLoading,
                        onPressed: _login,
                      ),
                    ),

                     SizedBox(height: 37.h),

                    // Delivery truck illustration
                    Center(
                      child: Image.asset(
                        AppImages.deliveryIcon,
                        height: 170.h,
                      ),
                    ),
                  ],
                ),
              )
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Directionality(
      textDirection: TextDirection.ltr,


      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding:  EdgeInsets.only(left: 26.0.w,
                top: 54.h),
            child: Image.asset(
              AppImages.logo,
              height: 74.h,
              width: 170.w,
              // width: 170.w,
            ),
          ),

          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                AppImages.ic_circlex2,

                // width: 170.w,
              ),

               Padding(
                 padding: EdgeInsets.only(
                   top: 16,
                   left: 16.w,right: 0,),
                 child: IconButton(
                    icon:Image.asset(AppImages.ic_language
                    ,width: 28.sp,
                      height: 28.sp,
                      color: AppColors.white,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        barrierColor: AppColors.black.withOpacity(0.40),
                        builder: (context) => LanguageSelector(
                          currentLanguage: getIt<AuthCubit>().languageNo=='2'?'en':'ar',
                          onLanguageSelected: (languageCode) async {
                            // Handle language change
                            print('Language selected: $languageCode');

                         await  getIt<AuthCubit>().changeLanguage(languageCode,
                             context: context);

                            // Update the state to reflect the selected language
                            // You can also use a state management solution like Provider or Bloc for this);
                         setState(() {

                         });

                          },
                        ),
                      );
                    },
                  ),
               )
            ],
          ),
        ],
      ),
    );
  }
}