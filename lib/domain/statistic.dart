class StatisticName {
  String name;

  StatisticName({this.name});

  StatisticName.fromJson(String json){
    name = json;
  }
}

//class AuditPharmName {
//  String pharmacy;
//  AuditPharmName({this.pharmacy});
//  AuditPharmName.fromJsonPharm(List<dynamic> json_){
//    pharmacy = json_[0].toString();
//    print(pharmacy);
//  }
//}

