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

  List<DeliveryBillModel> _orders = [];
  // Variables for filtering
  String? _statusFilter;
  String? _dateFilter;
  String? _searchQuery;

  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      emitOrders();
    }
  }

  Future<void> getDeliveryBills() async {
    emit(OrdersLoading());

    final processedFlag = tabController.index == 0 ? '0' : '1';

    try {
      _orders = await deliveryRepository.getDeliveryBills(
        Global.user!.deliveryNo,
        Global.user!.languageNo,
        processedFlag: processedFlag,
      );
      emitOrders();
    } catch (e) {
      emit(OrdersError('Failed to load orders. Please try again.'));
    }
  }

  Future<void> getFilteredDeliveryBills({
    String? statusFilter,
    String? dateFilter,
    String? searchQuery,
  }) async {
    emit(OrdersLoading());

    // Save the filter parameters
    _statusFilter = statusFilter;
    _dateFilter = dateFilter;
    _searchQuery = searchQuery;

    try {
      final processedFlag = tabController.index == 0 ? '0' : '1';

      _orders = await deliveryRepository.getFilteredDeliveryBills(
        Global.user!.deliveryNo,
        Global.user!.languageNo,
        processedFlag: processedFlag,
        statusFilter: statusFilter,
        dateFilter: dateFilter,
        searchQuery: searchQuery,
      );

      emitOrders();
    } catch (e) {
      emit(OrdersError('Failed to load filtered orders. Please try again.'));
    }
  }

  void resetFilters() {
    _statusFilter = null;
    _dateFilter = null;
    _searchQuery = null;
    getDeliveryBills();
  }

  Future<List<ReturnReasonModel>> getReturnReasons(String langNo) async {
    try {
      return await deliveryRepository.getReturnReasons(langNo);
    } catch (e) {
      throw Exception('Failed to load return reasons: ${e.toString()}');
    }
  }

  Future<List<StatusTypeModel>> getStatusTypes(String langNo) async {
    try {
      return await deliveryRepository.getStatusTypes(langNo);
    } catch (e) {
      throw Exception('Failed to load status types: ${e.toString()}');
    }
  }

  Future<bool> updateBillStatus(
      String billSrl,
      String statusFlag,
      String returnReason,
      String langNo,
      ) async {
    try {
      return await deliveryRepository.updateBillStatus(
        billSrl,
        statusFlag,
        returnReason,
        langNo,
      );
    } catch (e) {
      throw Exception('Failed to update bill status: ${e.toString()}');
    }
  }

  void emitOrders() {
    if (_orders.isEmpty) {
      emit(OrdersLoaded(_orders, []));
      return;
    }

    List<DeliveryBillModel> filteredOrders;

    if (_statusFilter != null || _dateFilter != null || _searchQuery != null) {
      // We already applied filters in the database query
      filteredOrders = _orders;
    } else {
      // Apply simple tab-based filtering
      filteredOrders = tabController.index == 0
          ? _orders.where((order) => order.statusFlag == '0').toList()
          : _orders.where((order) => order.statusFlag != '0').toList();
    }

    emit(OrdersLoaded(_orders, filteredOrders));
  }

  @override
  Future<void> close() {
    tabController.dispose();
    return super.close();
  }

  Future<void> clearOrders() async {
    _orders.clear();
    deliveryRepository.clearDeliveryData();

    emit(OrdersInitial());
  }
}

class _DefaultTickerProvider implements TickerProvider {
  const _DefaultTickerProvider();

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

