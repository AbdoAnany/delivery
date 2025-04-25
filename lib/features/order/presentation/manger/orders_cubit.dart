import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/order.dart';
import '../../data/repositories/order_repository.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrderRepository orderRepository;
  final TabController tabController;

  OrdersCubit({required this.orderRepository})
      : tabController = TabController(length: 2, vsync: const _DefaultTickerProvider()),
        super(OrdersInitial()) {
    tabController.addListener(_handleTabChange);
  }

  List<Order> _orders = [];
  final String _deliveryId = '1010'; // Would come from login

  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      emitOrders();
    }
  }

  Future<void> fetchOrders() async {
    emit(OrdersLoading());
    try {
      _orders = await orderRepository.getOrders(_deliveryId);
      emitOrders();
    } catch (e) {
      emit(OrdersError('Failed to load orders. Please try again.'));
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