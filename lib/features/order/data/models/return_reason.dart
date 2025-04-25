class ReturnReasonModel {
  final String reason;

  ReturnReasonModel({required this.reason});

  factory ReturnReasonModel.fromJson(Map<String, dynamic> json) {
    return ReturnReasonModel(
      reason: json['DLVRY_RTRN_RSN'] ?? '',
    );
  }

  factory ReturnReasonModel.fromDb(Map<String, dynamic> db) {
    return ReturnReasonModel.fromJson(db);
  }
}
