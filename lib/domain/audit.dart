class Audit {
  String dateandtime;
  bool delegate;
  bool delay;
  bool done;
//  String pharmacy;//id/name/will write
  int id;

  Audit({this.dateandtime, this.delegate, this.id, this.delay, this.done});

  Audit.fromJson(Map<String, dynamic> json){
    dateandtime = json["dateandtime"];
    delegate = json["delegate"];
    delay = json["delay"];
    done = json["done"];
  }


}

class AuditPharmName {
  String pharmacy;
  AuditPharmName({this.pharmacy});
  AuditPharmName.fromJsonPharm(List<dynamic> json_){
    pharmacy = json_[0].toString();
    print(pharmacy);
  }
}

