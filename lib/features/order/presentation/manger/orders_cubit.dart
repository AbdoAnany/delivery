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
  // final OrderRepository orderRepository;
  final DeliveryRepository deliveryRepository;
  final TabController tabController;

  OrdersCubit({required this.deliveryRepository})
      : tabController = TabController(length: 2, vsync: const _DefaultTickerProvider()),
        super(OrdersInitial()) {
    tabController.addListener(_handleTabChange);
  }

  List<DeliveryBillModel> _orders = [];
  final String _deliveryId = '1010';
  final String langNo = '2';

  // Would come from login

  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      emitOrders();
    }
  }

  Future<void> getDeliveryBills() async {


    emit(OrdersLoading());
    try {
      _orders = await deliveryRepository.getDeliveryBills(_deliveryId, langNo);
      emitOrders();
    } catch (e) {
      emit(OrdersError('Failed to load orders. Please try again.'));
    }
  }
  //  Future<List<DeliveryBillModel>> getDeliveryBills(String deliveryNo, String langNo, {String? billSrl, String? processedFlag});
  //   Future<List<dynamic>> getStatusTypes(String langNo);
  //   Future<List<dynamic>> getReturnReasons(String langNo);
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
Future<bool> updateBillStatus(String billSrl, String statusFlag, String returnReason, String langNo) async {
    try {
      return await deliveryRepository.updateBillStatus(billSrl, statusFlag, returnReason, langNo);
    } catch (e) {
      throw Exception('Failed to update bill status: ${e.toString()}');
    }
}

  void emitOrders() {
    if (_orders.isEmpty) {
      emit(OrdersLoaded(_orders, _orders));
      return;
    }

    final filteredOrders = tabController.index == 0
        ? _orders.where((order) => order.statusFlag == '0').toList()
        : _orders.where((order) => order.statusFlag != '0').toList();

    emit(OrdersLoaded(_orders, filteredOrders));
  }

  @override
  Future<void> close() {
    tabController.dispose();
    return super.close();
  }
}

class _DefaultTickerProvider implements TickerProvider {
  const _DefaultTickerProvider();

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}