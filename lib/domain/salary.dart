class SalaryFines {
  String fines;
  SalaryFines({this.fines});
  SalaryFines.fromJson(Map<String, dynamic> json){
    fines = json[0].toString();
//    print(fines);
  }
}

class SalaryUser {
  String salary;
  SalaryUser({this.salary});
  SalaryUser.fromJson(int json){
    salary = json.toString();
//    print(salary);
  }
}

class SalaryUserStavka {
  String salary;
  SalaryUserStavka({this.salary});
  SalaryUserStavka.fromJson(int json){
    salary = json.toString();
//    print(salary);
  }
}
class FinesStory {
  String fine;
  FinesStory({this.fine});
  FinesStory.fromJson(List<dynamic> json){
    fine = json[0]["statempfinesmonth"].toString();
    print(fine);
  }
}


