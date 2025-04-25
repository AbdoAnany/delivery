import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/AppColor.dart';


class EmptyState extends StatelessWidget {
  const EmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 24.h),
          Container(
            height: 183.h,
            width: 224.w,
            child: Image.asset(AppImages.ic_emptyorder),
          ),
          SizedBox(height: 20.h),
          Text(
            'No orders yet',
            style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48.w),
            child: Text(
              'You don\'t have any orders in your history.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w300,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}