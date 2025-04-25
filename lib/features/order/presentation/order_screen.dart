import 'package:delivery/features/order/presentation/widget/empty_state.dart';
import 'package:delivery/features/order/presentation/widget/loading_indicator.dart';
import 'package:delivery/features/order/presentation/widget/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/AppColor.dart';

import '../../login/presentation/HomeScreen.dart';
import '../data/repositories/order_repository.dart';

import 'manger/orders_cubit.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              OrdersCubit(orderRepository: OrderRepository())..fetchOrders(),
      child: const OrdersView(),
    );
  }
}

class OrdersView extends StatelessWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          _buildTabBar(context),
          _buildOrdersList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(context) {
    return Container(
      height: 127.h,
      color: AppColors.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16.0.w, top: 46.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ahmed',
                  style: TextStyle(
                    height: .5,
                    fontSize: 25.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  'Othman',
                  style: TextStyle(
                    fontSize: 25.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          _buildProfileImage(context),
        ],
      ),
    );
  }

  Widget _buildProfileImage(context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        // Image.asset(AppImages.ic_circle1, fit: BoxFit.contain),
        Container(
          width: 121.w,
          height: 127.h,
alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(AppImages.ic_circle1),
              fit: BoxFit.cover,
            ),
          ),

          child: Container(
            margin: EdgeInsets.only( right: 17.w),
            // width: 24.sp,
            // height: 24.sp,
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(5.5),
              // boxShadow: const [
              //   BoxShadow(
              //     color: Colors.grey,
              //     blurRadius: 6,
              //     offset: Offset(0, 3),
              //   ),
              // ],
            ),
            child: Image.asset(
              AppImages.ic_language,
              fit: BoxFit.contain,
              width: 16.sp,
              height: 16.sp,
            ),
          ),
        ),
        Positioned(
          left: -70.w,
          top: MediaQuery.of(context).padding.top /2,
          bottom: 0,
          child: Image.asset(
            AppImages.man,
            fit: BoxFit.contain,
            width: 134.w,
            height: 108.h,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      height: 36.h,
      width: 220.w,
      margin: EdgeInsets.only(top: 16.h, bottom: 28.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          return TabBar(
            controller: context.read<OrdersCubit>().tabController,
            indicator: BoxDecoration(
              color: const Color(0xFF2C3E50),
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            labelColor: Colors.white,
            padding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerHeight: 0,
            unselectedLabelColor: const Color(0xFF2C3E50),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [Tab(text: 'New'), Tab(text: 'Others')],
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context) {
    return Expanded(
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state is OrdersLoading) {
            return const Center(child: LoadingIndicator());
          } else if (state is OrdersError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Color(0xFFE74C3C)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<OrdersCubit>().fetchOrders(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is OrdersLoaded) {
            final orders = state.filteredOrders;
            if (orders.isEmpty) {
              return const EmptyState();
            }
            return RefreshIndicator(
              onRefresh: () => context.read<OrdersCubit>().fetchOrders(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return OrderItem(
                    order: orders[index],
                    onTap: (order) {
                      // Handle order tap
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
