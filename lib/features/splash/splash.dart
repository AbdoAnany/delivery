import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/image.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.babyBlue,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Onyx Delivery',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.babyBlue,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Image.asset(
                AppImages.logo,
                fit: BoxFit.cover,
                height: 112.h,
              ),
            ),
          ),
          Container(
            height: 245.h,
            width: double.infinity,
            padding: EdgeInsets.only(top: 60.h,bottom: 32.h),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.tawen),
                fit: BoxFit.cover,
              ),
            ),
            child: Image.asset(
              AppImages.delivaryBuke,
              width: 270.w,
              fit: BoxFit.contain,
              height: 209.h,
            ),
          ),
        ],
      ),
    );
  }
}