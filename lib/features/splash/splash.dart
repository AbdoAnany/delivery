import 'package:delivery/core/AppColor.dart';
import 'package:flutter/material.dart';

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
          Expanded(      child: Center(
              child: Text(
                'Onyx Delivery',
                style: TextStyle(
                  fontSize: 32,
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
                // width: 200,
                fit: BoxFit.cover,
                height: 112,
              ),
            ),
          ),
          Container(
            height: 245,
            width: double.infinity,

            margin: EdgeInsets.only(bottom: 32),
 padding: EdgeInsets.only(top: 60),
           decoration: BoxDecoration(
             image: DecorationImage(
               image: AssetImage(AppImages.tawen),
               fit: BoxFit.cover,
             ),
           ),child: Image.asset(
              AppImages.delivaryBuke,
            width: 270,
            fit: BoxFit.contain,
            height: 209,

          ),
          ),
        ],
      ),
    );
  }
}