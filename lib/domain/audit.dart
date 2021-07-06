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
    id = json["id"];
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
class AuditDone {
  String dateandtime;
//  bool delegate;
  String done;
  String delay;
  AuditDone({this.dateandtime,  this.done, this.delay});
  AuditDone.fromJson(Map<String, dynamic> json_){
    dateandtime = json_["dateandtime"].toString();
//    delegate = json_[0];
    done = json_['done'].toString();
    delay = json_['delay'].toString();
    print(dateandtime);
  }
}

class AuditDelay {
  String dateandtime;
//  bool delegate;
  String done;
  String delay;
  AuditDelay({this.dateandtime,  this.done, this.delay});
  AuditDelay.fromJson(Map<String, dynamic> json_){
    dateandtime = json_["dateandtime"].toString();
//    delegate = json_[0];
    done = json_['done'].toString();
    delay = json_['delay'].toString();
    print(dateandtime);
  }
}

class AuditPlan {
  String dateandtime;
//  bool delegate;
  String done;
  String delay;
  AuditPlan({this.dateandtime,  this.done, this.delay});
  AuditPlan.fromJson(Map<String, dynamic> json_){
    dateandtime = json_["dateandtime"].toString();
//    delegate = json_[0];
    done = json_['done'].toString();
    delay = json_['delay'].toString();
    print(dateandtime);
  }
}


