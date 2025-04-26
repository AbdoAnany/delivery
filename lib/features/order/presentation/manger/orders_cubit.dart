import 'package:delivery/core/utils/Global.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../data/models/delivery_bill.dart';
import '../../data/models/return_reason.dart';
import '../../data/models/status_type.dart';
import '../../data/repositories/order_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final DeliveryRepository deliveryRepository;
  final TabController tabController;

  OrdersCubit({required this.deliveryRepository})
      : tabController = TabController(
    length: 2,
    vsync: const _DefaultTickerProvider(),
  ),
        super(OrdersInitial()) {
    tabController.addListener(_handleTabChange);
  }

  List<DeliveryBillModel> _allOrders = [];
  List<DeliveryBillModel> _filteredOrders = [];

  // Filter parameters
  String? _statusFilter;
  String? _dateFilter;
  String? _searchQuery;
  bool _isRefreshing = false;

  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      _applyFilters();
    }
  }

  Future<void> getDeliveryBills({bool isRefresh = false, String? processedFlag, bool? sortAscending=true}) async {
    if (isRefresh) {
      _isRefreshing = true;
    } else {
      emit(OrdersLoading());
    }

    try {
      // _allOrders = await deliveryRepository.getDeliveryBills(
      //   Global.user!.deliveryNo,
      //   Global.user!.languageNo,
      //     processedFlag: processedFlag,
      //
      // );
      // print('_allOrders  ${_allOrders.length}');

      _applyFilters();
    } catch (e) {
      print('Error fetching bills: $e');
      if (!isClosed) {
        emit(OrdersError('Failed to load orders: ${e.toString()}'));
      }
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _applyFilters() async {
    if (_allOrders.isEmpty) {
      emit(OrdersLoaded(_allOrders, []));
      return;
    }

    // Start with all orders
    _filteredOrders = List.from(_allOrders);


    // Apply status filter if set
    if (_statusFilter != null) {
      _filteredOrders =await deliveryRepository.getDeliveryBills(   Global.user!.deliveryNo,
        Global.user!.languageNo,
        processedFlag: _statusFilter!.isEmpty ? null : _statusFilter,);
          // _filteredOrders
          // .where((order) => order.statusFlag == _statusFilter)
          // .toList();
    }
    // Apply tab filter first
    _filteredOrders = tabController.index == 0
        ? _filteredOrders.where((order) => order.statusFlag == '0').toList()
        : _filteredOrders.where((order) => order.statusFlag != '0').toList();

    // Apply date filter if set
    if (_dateFilter != null) {
      final now = DateTime.now();
      _filteredOrders = _filteredOrders.where((order) {
        final orderDate = _parseOrderDate(order.date);
        switch (_dateFilter) {
          case 'today':
            return orderDate.year == now.year &&
                orderDate.month == now.month &&
                orderDate.day == now.day;
          case 'this_week':
            final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
            return orderDate.isAfter(startOfWeek);
          case 'this_month':
            return orderDate.year == now.year && orderDate.month == now.month;
          default:
            return true;
        }
      }).toList();
    }

    // Apply search query if set
    if (_searchQuery?.isNotEmpty == true) {
      final query = _searchQuery!.toLowerCase();
      _filteredOrders = _filteredOrders.where((order) {
        return (order.customerName?.toLowerCase().contains(query) ?? false) ||
            order.billNo.toLowerCase().contains(query) ||
            (order.region?.toLowerCase().contains(query) ?? false) ||
            (order.address?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    if (!_isRefreshing) {
      emit(OrdersLoaded(_allOrders, _filteredOrders));
    }
  }

  DateTime _parseOrderDate(String dateString) {
    try {
      final parts = dateString.split('/');
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (e) {
      return DateTime.now();
    }
  }

  void setStatusFilter(String? status) {
    _statusFilter = status;
    _applyFilters();
  }

  void setDateFilter(String? date) {
    _dateFilter = date;
    _applyFilters();
  }

  void setSearchQuery(String? query) {
    _searchQuery = query;
    _applyFilters();
  }

  void resetFilters() {
    _statusFilter = null;
    _dateFilter = null;
    _searchQuery = null;
    _applyFilters();
  }

  Future<void> refreshOrders() async {
    await getDeliveryBills(isRefresh: true);
    if (!isClosed) {
      emit(OrdersLoaded(_allOrders, _filteredOrders));
    }
  }

  Future<List<ReturnReasonModel>> getReturnReasons() async {
    try {
      return await deliveryRepository.getReturnReasons(Global.user!.languageNo);
    } catch (e) {
      throw Exception('Failed to load return reasons: ${e.toString()}');
    }
  }

  Future<List<StatusTypeModel>> getStatusTypes() async {
    try {
      return await deliveryRepository.getStatusTypes(Global.user!.languageNo);
    } catch (e) {
      throw Exception('Failed to load status types: ${e.toString()}');
    }
  }

  Future<bool> updateBillStatus({
    required String billSrl,
    required String statusFlag,
    String? returnReason,
  }) async {
    try {
      final success = await deliveryRepository.updateBillStatus(
        billSrl,
        statusFlag,
        returnReason ?? '',
        Global.user!.languageNo,
      );

      if (success) {
        await refreshOrders();
      }

      return success;
    } catch (e) {
      throw Exception('Failed to update bill status: ${e.toString()}');
    }
  }

  @override
  Future<void> close() {
    tabController.dispose();
    return super.close();
  }

  Future<void> clearOrders() async {
    _allOrders.clear();
    _filteredOrders.clear();
    await deliveryRepository.clearDeliveryData();
    emit(OrdersInitial());
  }


}

class _DefaultTickerProvider implements TickerProvider {
  const _DefaultTickerProvider();

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}