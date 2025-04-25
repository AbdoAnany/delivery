import 'package:delivery/features/order/presentation/widget/empty_state.dart';
import 'package:delivery/features/order/presentation/widget/loading_indicator.dart';
import 'package:delivery/features/order/presentation/widget/order_item.dart';
import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/image.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/utils/Global.dart';
import '../../login/presentation/manger/auth_cubit.dart';
import '../../login/presentation/widget/LanguageSelector.dart';

import 'bill_details.dart';
import 'manger/orders_cubit.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final OrdersCubit _ordersCubit;

  @override
  void initState() {
    super.initState();
    _ordersCubit = getIt<OrdersCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ordersCubit.getDeliveryBills();
    });
  }

  @override
  void dispose() {
    _ordersCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _ordersCubit,
      child: const OrdersView(),
    );
  }
}
class _OrdersScreenContent extends StatefulWidget {
  const _OrdersScreenContent();

  @override
  State<_OrdersScreenContent> createState() => __OrdersScreenContentState();
}

class __OrdersScreenContentState extends State<_OrdersScreenContent> {
  @override
  void initState() {
    super.initState();
    // Delay the call to avoid race conditions
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersCubit>().getDeliveryBills();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const OrdersView();
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
          _buildFilter(context),
          _buildOrdersList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 127.h,

        color: AppColors.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*.5,
              padding: EdgeInsets.only(left: 16.0.w, top: 46.h),
              child:      Text(
                Global.user?.name??'No Name',
                maxLines: 2,
                style: TextStyle(
                  // height: .5,
                  fontSize: 25.sp,
                  overflow: TextOverflow.ellipsis,
                  color: AppColors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            _buildProfileImage(context),
          ],
        ),
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

          child: GestureDetector(
            onTap: () {

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


                    },
                  ),
                );

            },
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
            onTap: (index) {
              // context.read<OrdersCubit>().getDeliveryBills();
            },
            labelColor: Colors.white,
            padding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            dividerHeight: 0,
            unselectedLabelColor: const Color(0xFF2C3E50),
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs:  [Tab(text: 'New'.tr()), Tab(text: 'Others'.tr())],
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
                    onPressed: () => context.read<OrdersCubit>().getDeliveryBills(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is OrdersLoaded) {
            final orders = state.filteredOrders;
            if (orders.isEmpty) {
              return  RefreshIndicator(
                  onRefresh: () => context.read<OrdersCubit>().getDeliveryBills(),
                  child: const EmptyState());
            }
            return RefreshIndicator(
              onRefresh: () => context.read<OrdersCubit>().getDeliveryBills(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  return OrderItem(
                    order: orders[index],
                    onTap: (bill) {
                      // Handle order item tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BillDetailScreen(bill: bill, ),
                        ),
                      );
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

 Widget _buildFilter(BuildContext context) {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter button press
            },
          ),
          const Text('Filter'),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
    );
 }
}
