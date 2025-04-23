// login_screen.dart
import 'package:delivery/features/login/presentation/widget/CustomTextField.dart';
import 'package:delivery/features/login/presentation/widget/LanguageSelector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../core/AppColor.dart';
import 'manger/AuthProvider.dart';
import 'manger/auth_cubit.dart';
import 'manger/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deliveryNoController = TextEditingController(text: '1010');
  final _passwordController = TextEditingController(text: '1');
  bool _passwordVisible = false;

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
      languageNo: '2',
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
          toolbarHeight: 74,
      ),
      backgroundColor:  AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child:  Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // App logo and language selector area


                      const SizedBox(height: 132),

                      // Welcome message
                      Center(
                        child: Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 29,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Center(
                        child: Text(
                          'Log back into your account',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 44),

                      // User ID field
                      CustomTextField(
                        controller: _deliveryNoController,
                        hintText: 'User ID',
                        validator: (value) => value?.isEmpty ?? true
                            ? 'User ID is required'
                            : null,
                      ),

                      const SizedBox(height: 8),

                      // Password field
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: !_passwordVisible,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Password is required'
                            : null,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },

                        ),
                      ),

                      const SizedBox(height: 27),
                   Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Text(
                          _passwordVisible ? 'Hide' : 'Show More',
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 44,
                        child: CustomButton(
                          text: 'Log in',
                          isLoading: state is AuthLoading,
                          onPressed: _login,
                        ),
                      ),

                      const SizedBox(height: 37),

                      // Delivery truck illustration
                      Center(
                        child: Image.asset(
                          AppImages.deliveryIcon,
                          height: 170,
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 26, top: 56),
          child: Image.asset(
            AppImages.logo,
            width: 170,
          ),
        ),
        Container(
          width: 121,
          height: 127,
          padding: const EdgeInsets.only(left: 78,right: 16,
              bottom: 49,
              top: 51),

          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(

                bottomLeft: Radius.circular(1000)),

          ),
          child: IconButton(
            icon: const Icon(Icons.language,
                color: Colors.white,
                size: 27
            ),
            onPressed: () {
              showDialog(
                context: context,
                barrierColor: AppColors.black.withOpacity(0.40),
                builder: (context) => LanguageSelector(
                  currentLanguage: 'en', // Get current language from your state
                  onLanguageSelected: (languageCode) {
                    // Handle language change
                    Provider.of<AuthProvider>(context, listen: false)
                        .changeLanguage(languageCode);
                  },
                ),
              );
            },
          )
        ),
      ],
    );
  }
}