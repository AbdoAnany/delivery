part of 'orders_cubit.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<DeliveryBillModel> allOrders;
  final List<DeliveryBillModel> filteredOrders;
  final bool isFiltered;

  const OrdersLoaded(
    this.allOrders, 
    this.filteredOrders, {
    this.isFiltered = false,
  });

  @override
  List<Object> get props => [allOrders, filteredOrders, isFiltered];
}

class OrdersError extends OrdersState {
  final String message;

  const OrdersError(this.message);

  @override
  List<Object> get props => [message];
}
