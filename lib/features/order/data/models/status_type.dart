class StatusTypeModel {
  final String typNo;
  final String typNm;

  StatusTypeModel({
    required this.typNo,
    required this.typNm,
  });

  factory StatusTypeModel.fromJson(Map<String, dynamic> json) {
    return StatusTypeModel(
      typNo: json['TYP_NO'] ?? '',
      typNm: json['TYP_NM'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'TYP_NO': typNo,
      'TYP_NM': typNm,
    };
  }

  factory StatusTypeModel.fromDb(Map<String, dynamic> db) {
    return StatusTypeModel.fromJson(db);
  }
}
