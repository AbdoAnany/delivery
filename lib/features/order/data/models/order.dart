class Order {
  final String billSrl;
  final String billType;
  final String billNo;
  final String statusFlag;
  final double totalAmount;
  final String date;
  final String time;
  final String? customerName;
  final String? mobileNumber;
  final String? region;
  final String? address;
  final String? buildingNo;
  final String? floorNo;
  final String? apartmentNo;
  final double? deliveryAmount;
  final double? taxAmount;
  final double? latitude;
  final double? longitude;

  Order({
    required this.billSrl,
    required this.billType,
    required this.billNo,
    required this.statusFlag,
    required this.totalAmount,
    required this.date,
    required this.time,
    this.customerName,
    this.mobileNumber,
    this.region,
    this.address,
    this.buildingNo,
    this.floorNo,
    this.apartmentNo,
    this.deliveryAmount,
    this.taxAmount,
    this.latitude,
    this.longitude,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      billSrl: json['BILL_SRL']?.toString() ?? '',
      billType: json['BILL_TYPE']?.toString() ?? '',
      billNo: json['BILL_NO']?.toString() ?? '',
      statusFlag: json['DLVRY_STATUS_FLG']?.toString() ?? '0',
      totalAmount: double.tryParse(json['BILL_AMT']?.toString() ?? '0') ?? 0.0,
      date: json['BILL_DATE']?.toString() ?? '',
      time: json['BILL_TIME']?.toString() ?? '',
      customerName: json['CSTMR_NM']?.toString(),
      mobileNumber: json['MOBILE_NO']?.toString(),
      region: json['RGN_NM']?.toString(),
      address: json['CSTMR_ADDRSS']?.toString(),
      buildingNo: json['CSTMR_BUILD_NO']?.toString(),
      floorNo: json['CSTMR_FLOOR_NO']?.toString(),
      apartmentNo: json['CSTMR_APRTMNT_NO']?.toString(),
      deliveryAmount: double.tryParse(json['DLVRY_AMT']?.toString() ?? '0'),
      taxAmount: double.tryParse(json['TAX_AMT']?.toString() ?? '0'),
      latitude: double.tryParse(json['LATITUDE']?.toString() ?? ''),
      longitude: double.tryParse(json['LONGITUDE']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BILL_SRL': billSrl,
      'BILL_TYPE': billType,
      'BILL_NO': billNo,
      'DLVRY_STATUS_FLG': statusFlag,
      'BILL_AMT': totalAmount,
      'BILL_DATE': date,
      'BILL_TIME': time,
      'CSTMR_NM': customerName,
      'MOBILE_NO': mobileNumber,
      'RGN_NM': region,
      'CSTMR_ADDRSS': address,
      'CSTMR_BUILD_NO': buildingNo,
      'CSTMR_FLOOR_NO': floorNo,
      'CSTMR_APRTMNT_NO': apartmentNo,
      'DLVRY_AMT': deliveryAmount,
      'TAX_AMT': taxAmount,
      'LATITUDE': latitude,
      'LONGITUDE': longitude,
    };
  }

  String get formattedAddress {
    final parts = [
      if (buildingNo?.isNotEmpty ?? false) 'Building $buildingNo',
      if (floorNo?.isNotEmpty ?? false) 'Floor $floorNo',
      if (apartmentNo?.isNotEmpty ?? false) 'Apartment $apartmentNo',
      region,
      address,
    ].where((part) => part != null && part.isNotEmpty).toList();

    return parts.join(', ');
  }

  String get status {
    switch (statusFlag) {
      case '0':
        return 'New';
      case '1':
        return 'Delivered';
      case '2':
        return 'In Progress';
      case '3':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  String get formattedDateTime {
    try {
      final dateParts = date.split('/');
      if (dateParts.length == 3) {
        return '${dateParts[0]}/${dateParts[1]}/${dateParts[2]} at ${time.substring(0, 5)}';
      }
    } catch (e) {
      return '$date at ${time.substring(0, 5)}';
    }
    return '$date at ${time.substring(0, 5)}';
  }

  double get totalWithTaxAndDelivery {
    return (totalAmount) + (taxAmount ?? 0) + (deliveryAmount ?? 0);
  }
}