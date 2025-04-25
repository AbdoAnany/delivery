import 'package:delivery/core/constants/colors.dart';
import 'package:delivery/core/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/dependency_injection.dart';
import '../../../core/utils/language_util.dart';
import '../data/models/delivery_bill.dart';
import '../data/models/return_reason.dart';
import '../data/models/status_type.dart';
import 'manger/orders_cubit.dart';

class BillDetailScreen extends StatelessWidget {
  const BillDetailScreen({super.key, required this.bill});
  final DeliveryBillModel bill;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersCubit>(),
      child: BillDetailScreenOverview(bill: bill),
    );
  }
}

class BillDetailScreenOverview extends StatefulWidget {
  final DeliveryBillModel bill;

  const BillDetailScreenOverview({
    Key? key,
    required this.bill,
  }) : super(key: key);

  @override
  _BillDetailScreenState createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreenOverview> {
  bool _isLoading = false;
  bool _isUpdating = false;
  String? _errorMessage;
  List<StatusTypeModel> _statusTypes = [];
  List<ReturnReasonModel> _returnReasons = [];
  String? _selectedStatusType;
  String? _selectedReason;

  @override
  void initState() {
    super.initState();
    _selectedStatusType = widget.bill.statusFlag;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final langNo = LanguageUtil.getCurrentLanguage();


      _statusTypes =await  getIt<OrdersCubit>().getStatusTypes();
    _returnReasons  = await getIt<OrdersCubit>().getReturnReasons();

      setState(() {


        // Ensure the selected status exists in the loaded types
        if (!_statusTypes.any((type) => type.typNo == _selectedStatusType)) {
          _selectedStatusType = null;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateBillStatus() async {
    if (_selectedStatusType == null) {
      AppToast.info(context: context, message: 'Please select a status');

      return;
    }

    if (_selectedStatusType == '2' || _selectedStatusType == '3') {
      if (_selectedReason == null) {
        AppToast.info(context: context, message: 'Please select a return reason');

        return;
      }
    }

    setState(() {
      _isUpdating = true;
      _errorMessage = null;
    });

    try {
      final success = await context.read<OrdersCubit>().updateBillStatus(

        // _selectedStatusType!,
        // _selectedReason ?? '',
        // LanguageUtil.getCurrentLanguage(),
        billSrl:  widget.bill.billSrl, statusFlag:  widget.bill.statusFlag,
      );

      if (success) {
        if (mounted) {
AppToast.success(context: context, message: 'Status updated successfully');

          Navigator.of(context).pop(true); // Return true to indicate success
        }
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      if (mounted) {
        AppToast.error(context: context, message: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Bill #${widget.bill.billNo}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bill Details Card
            _buildBillDetailsCard(context),
            const SizedBox(height: 16),
            // Customer Information Card
            _buildCustomerInfoCard(context),
            const SizedBox(height: 16),
            // Update Status Card
            _buildStatusUpdateCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBillDetailsCard(BuildContext context) {
    return Card(

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bill Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            _buildDetailsRow('Bill No', widget.bill.billNo),
            _buildDetailsRow('Serial', widget.bill.billSrl),
            _buildDetailsRow('Date', '${widget.bill.date} ${widget.bill.time}'),
            _buildDetailsRow('Amount', widget.bill.totalAmount.toStringAsFixed(2)),
            _buildDetailsRow('Tax', widget.bill.taxAmount?.toStringAsFixed(2) ?? '0.00'),
            _buildDetailsRow('Delivery Fee', widget.bill.deliveryAmount?.toStringAsFixed(2) ?? '0.00'),
            _buildDetailsRow(
              'Total',
              (widget.bill.totalAmount +
                  (widget.bill.taxAmount ?? 0) +
                  (widget.bill.deliveryAmount ?? 0))
                  .toStringAsFixed(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            _buildDetailsRow('Name', widget.bill.customerName),
            _buildDetailsRow('Mobile', widget.bill.mobileNumber),
            _buildDetailsRow('Region', widget.bill.region),
            _buildDetailsRow('Building No', widget.bill.buildingNo),
            _buildDetailsRow('Floor No', widget.bill.floorNo),
            _buildDetailsRow('Apartment No', widget.bill.apartmentNo),
            _buildDetailsRow(
                'Address', widget.bill.address?.isNotEmpty == true ? widget.bill.address : 'N/A'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusUpdateCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Update Status',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              value: _selectedStatusType,
              items: _statusTypes.map((type) {
                return DropdownMenuItem<String>(
                  value: type.typNo,
                  child: Text(type.typNm),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatusType = value;
                  if (value != '2' && value != '3') {
                    _selectedReason = null;
                  }
                });
              },
              validator: (value) =>
              value == null ? 'Please select a status' : null,
            ),
            if (_selectedStatusType == '2' || _selectedStatusType == '3') ...[
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Return Reason',
                  border: OutlineInputBorder(),
                ),
                value: _selectedReason,
                items: _returnReasons.map((reason) {
                  return DropdownMenuItem<String>(
                    value: reason.reason,
                    child: Text(reason.reason),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value;
                  });
                },
                validator: (value) => (_selectedStatusType == '2' ||
                    _selectedStatusType == '3') &&
                    value == null
                    ? 'Please select a reason'
                    : null,
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: _isUpdating
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _updateBillStatus,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Update Status'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value?.isNotEmpty == true ? value! : 'N/A'),
          ),
        ],
      ),
    );
  }
}