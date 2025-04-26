import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery/core/constants/colors.dart';

import '../../../../core/constants/image.dart';
import '../manger/orders_cubit.dart';


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
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<OrdersCubit>().getDeliveryBills(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}