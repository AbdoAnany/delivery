class DeliveryBill {
  String? bILLTYPE;
  String? bILLNO;
  String? bILLSRL;
  String? bILLDATE;
  String? bILLTIME;
  String? bILLAMT;
  String? tAXAMT;
  String? dLVRYAMT;
  String? mOBILENO;
  String? cSTMRNM;
  String? rGNNM;
  String? cSTMRBUILDNO;
  String? cSTMRFLOORNO;
  String? cSTMRAPRTMNTNO;
  String? cSTMRADDRSS;
  String? lATITUDE;
  String? lONGITUDE;
  String? dLVRYSTATUSFLG;

  DeliveryBill(
      {this.bILLTYPE,
        this.bILLNO,
        this.bILLSRL,
        this.bILLDATE,
        this.bILLTIME,
        this.bILLAMT,
        this.tAXAMT,
        this.dLVRYAMT,
        this.mOBILENO,
        this.cSTMRNM,
        this.rGNNM,
        this.cSTMRBUILDNO,
        this.cSTMRFLOORNO,
        this.cSTMRAPRTMNTNO,
        this.cSTMRADDRSS,
        this.lATITUDE,
        this.lONGITUDE,
        this.dLVRYSTATUSFLG});

  DeliveryBill.fromJson(Map<String, dynamic> json) {
    bILLTYPE = json['BILL_TYPE'];
    bILLNO = json['BILL_NO'];
    bILLSRL = json['BILL_SRL'];
    bILLDATE = json['BILL_DATE'];
    bILLTIME = json['BILL_TIME'];
    bILLAMT = json['BILL_AMT'];
    tAXAMT = json['TAX_AMT'];
    dLVRYAMT = json['DLVRY_AMT'];
    mOBILENO = json['MOBILE_NO'];
    cSTMRNM = json['CSTMR_NM'];
    rGNNM = json['RGN_NM'];
    cSTMRBUILDNO = json['CSTMR_BUILD_NO'];
    cSTMRFLOORNO = json['CSTMR_FLOOR_NO'];
    cSTMRAPRTMNTNO = json['CSTMR_APRTMNT_NO'];
    cSTMRADDRSS = json['CSTMR_ADDRSS'];
    lATITUDE = json['LATITUDE'];
    lONGITUDE = json['LONGITUDE'];
    dLVRYSTATUSFLG = json['DLVRY_STATUS_FLG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BILL_TYPE'] = this.bILLTYPE;
    data['BILL_NO'] = this.bILLNO;
    data['BILL_SRL'] = this.bILLSRL;
    data['BILL_DATE'] = this.bILLDATE;
    data['BILL_TIME'] = this.bILLTIME;
    data['BILL_AMT'] = this.bILLAMT;
    data['TAX_AMT'] = this.tAXAMT;
    data['DLVRY_AMT'] = this.dLVRYAMT;
    data['MOBILE_NO'] = this.mOBILENO;
    data['CSTMR_NM'] = this.cSTMRNM;
    data['RGN_NM'] = this.rGNNM;
    data['CSTMR_BUILD_NO'] = this.cSTMRBUILDNO;
    data['CSTMR_FLOOR_NO'] = this.cSTMRFLOORNO;
    data['CSTMR_APRTMNT_NO'] = this.cSTMRAPRTMNTNO;
    data['CSTMR_ADDRSS'] = this.cSTMRADDRSS;
    data['LATITUDE'] = this.lATITUDE;
    data['LONGITUDE'] = this.lONGITUDE;
    data['DLVRY_STATUS_FLG'] = this.dLVRYSTATUSFLG;
    return data;
  }
}
