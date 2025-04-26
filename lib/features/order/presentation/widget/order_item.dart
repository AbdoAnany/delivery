import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/delivery_bill.dart';

class OrderItem extends StatelessWidget {
  final DeliveryBillModel order;
  final Function(DeliveryBillModel) onTap;

  const OrderItem({
    Key? key,
    required this.order,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();

    return Card(
      margin: const EdgeInsetsDirectional.only(bottom: 16),
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        height: 91.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOrderInfo(context),
            _buildDetailsButton(statusColor),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.only(start: 20.w, top: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#${order.billNo}',
              textDirection: TextDirection.ltr,
              style: TextStyle(


                color: AppColors.grey,
                fontSize: 12.sp,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStatusColumn(),
                _buildDivider(),
                _buildPriceColumn(),
                _buildDivider(),
                _buildDateColumn(),
                // SizedBox(width: 8.w),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Status'.tr(),
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 10.sp,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              _mapStatusFlag(order.statusFlag).trim(),

              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                color: _getStatusColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceColumn() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 7.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Total Price'.tr(),
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 10.sp,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
                child: Text(
                  '${order.totalAmount.toStringAsFixed(0)} LE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.w,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateColumn() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Date'.tr(),
            style: TextStyle(
              color: AppColors.grey,
              fontSize: 10.sp,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
              child: Text(
                order.date,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.w,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.lightGrey,
    );
  }

  Widget _buildDetailsButton(Color statusColor) {
    return Container(
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: const BorderRadiusDirectional.only(
          topEnd: Radius.circular(10),
          bottomEnd: Radius.circular(10),
        ),
      ),
      child: InkWell(
        onTap: () => onTap(order),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        child: SizedBox(
          width: 44.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 36.h),
              // Padding(
              //   padding:  EdgeInsets.symmetric(horizontal: 2.0.w),
              //   child: Text(
              //     order.statusFlag,
              //     maxLines: 1,
              //     style: TextStyle(color: Colors.white, fontSize: 8.sp),
              //     textAlign: TextAlign.center,
              //
              //   ),
              // ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 2.0.w),
                child: Text(
                  'Order Details'.tr(),
                  maxLines: 2,
                  style: TextStyle(color: Colors.white, fontSize: 8.sp),
                  textAlign: TextAlign.center,

                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 20.sp,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
  static String _mapStatusFlag(String flag) {
    switch (flag) {
      case '0':
        return 'New';
      case '1':
        return 'Delivered';
      case '2':
        return 'Delivering';
      case '3':
        return 'Returned';
      default:
        return 'New';
    }
  }

  Color _getStatusColor() {
    switch (order.statusFlag.toLowerCase()) {
      case '0':
        return AppColors.success; // Green
      case '1':
        return AppColors.textSecondary ; // Dark blue
      case '2':
        return  AppColors.textPrimary; // Gray
      case '3':
        return  AppColors.primary; // Red
      default:
        return const Color(0xFF29D40F); // Default green
    }
  }
}