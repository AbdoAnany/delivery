
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/datasources/local/database_helper.dart';
import '../data/datasources/remote/api_service.dart';
import '../data/model/Order.dart';
import 'manger/AuthProvider.dart';
import 'manger/SessionManager.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final SessionManager _sessionManager;
  List<DeliveryBill> _orders = [];
  bool _isLoading = false;
  String _selectedFilter = '';

  @override
  void initState() {
    super.initState();
    // _sessionManager = SessionManager(_onSessionExpired);
    _loadOrders();
  }

  void _onSessionExpired() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final apiService = Provider.of<ApiService>(context, listen: false);
      final dbHelper = Provider.of<DatabaseHelper>(context, listen: false);
      
      // Fetch from API
      final orders = await apiService.getDeliveryBillsItems(
        deliveryNo: authProvider.deliveryNo!,
        languageNo: authProvider.languageNo!,
      );
      
      // Save to local database
      await dbHelper.insertOrders(orders);
      
      // Load from local database
      _orders = await dbHelper.getFilteredOrders(status: _selectedFilter);
      
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load orders: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _applyFilter(String? status) async {
    setState(() {
      _selectedFilter = status ?? '';
      _isLoading = true;
    });
    
    try {
      final dbHelper = Provider.of<DatabaseHelper>(context, listen: false);
      _orders = await dbHelper.getFilteredOrders(status: _selectedFilter);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Filter error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          DropdownButton<String>(
            value: _selectedFilter.isEmpty ? null : _selectedFilter,
            hint: const Text('Filter'),
            items: const [
              DropdownMenuItem(value: '', child: Text('All')),
              DropdownMenuItem(value: '1', child: Text('New')),
              DropdownMenuItem(value: '2', child: Text('Processing')),
              DropdownMenuItem(value: '3', child: Text('Completed')),
            ],
            onChanged: _applyFilter,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('No orders found'))
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return OrderCard(order: order);
                  },
                ),
    );
  }

  @override
  void dispose() {
    _sessionManager.dispose();
    super.dispose();
  }
}

class OrderCard extends StatelessWidget {
  final DeliveryBill order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Order ID: ${order..bILLNO}'),
        subtitle: Text('Status: ${order.dLVRYSTATUSFLG}'),
      ),
    );
  }}