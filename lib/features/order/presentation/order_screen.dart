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

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => getIt<OrdersCubit>()..getDeliveryBills(),
        child:OrdersView()

    );
  }
}

class OrdersView extends StatefulWidget {
   const OrdersView({Key? key}) : super(key: key);

  @override
  State<OrdersView> createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  String? _selectedStatusFilter;

  String? _selectedDateFilter;

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          _buildTabBar(context),
          _buildFilterSection(context),
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
                   height: .9,
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

  Widget _buildFilterSection(BuildContext context) {
    return      Row(
      children: [
        SizedBox(width: 8.w),

        Expanded(
          flex: 4,
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _selectedStatusFilter != null ? AppColors.primary : Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedStatusFilter,
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                isExpanded: true,
                hint: Padding(
                  padding: EdgeInsetsDirectional.only(start: 13.w),
                  child: Text('Status'.tr(), style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                borderRadius: BorderRadius.circular(15),
                items: [
                  DropdownMenuItem(value: '', child: Center(child: Text('all'.tr(), textAlign: TextAlign.center,style: TextStyle(fontSize: 13.sp,)))),
                  DropdownMenuItem(value: '0', child: Center(child: Text('New'.tr(), style: TextStyle(fontSize: 13.sp)))),
                  DropdownMenuItem(value: '1', child: Center(child: Text('delivered'.tr(), style: TextStyle(fontSize: 13.sp)))),
                  DropdownMenuItem(value: '2', child: Center(child: Text('delivering'.tr(), style: TextStyle(fontSize: 13.sp)))),
                  DropdownMenuItem(value: '3', child: Center(child: Text('returned'.tr(), style: TextStyle(fontSize: 13.sp)))),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatusFilter = value;
                  });
                  context.read<OrdersCubit>().setStatusFilter(value);
                },
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),

        // Date dropdown (takes 30% of width)
        Expanded(
          flex: 3,
          child: Container(
            height: 44.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: _selectedDateFilter != null ? AppColors.primary : Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedDateFilter,
                icon: Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                isExpanded: true,
                hint: Padding(
                  padding: EdgeInsetsDirectional.only(start: 13.w),
                  child: Text('Date'.tr(), style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                borderRadius: BorderRadius.circular(15),
                items: [
                  DropdownMenuItem(value: '', child: Text('all'.tr(), style: TextStyle(fontSize: 13.sp))),
                  DropdownMenuItem(value: 'today', child: Text('today'.tr(), style: TextStyle(fontSize: 13.sp))),
                  DropdownMenuItem(value: 'this_week', child: Text('this_week'.tr(), style: TextStyle(fontSize: 13.sp))),
                  DropdownMenuItem(value: 'this_month', child: Text('this_month'.tr(), style: TextStyle(fontSize: 13.sp))),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDateFilter = value;
                  });
                  context.read<OrdersCubit>().setDateFilter(value);
                },
              ),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        if (_selectedStatusFilter != null || _selectedDateFilter != null || _searchController.text.isNotEmpty)
        ...[
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _selectedStatusFilter = null;
                  _selectedDateFilter = null;
                  _searchController.clear();
                });
                context.read<OrdersCubit>().resetFilters();
              },
              icon: const Icon(Icons.refresh, size: 16),
              // label: Text('clear_all'.tr(), style: TextStyle(fontSize: 12.sp)),
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0),
                minimumSize: Size.zero,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ]
      ],
    );
  }

}
