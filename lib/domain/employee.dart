class Employee {
  String position;
  String fullname;
  int salaryrate;
  String geolocation;
  int id;

  Employee({this.position, this.fullname, this.salaryrate, this.geolocation, this.id});//without {}
  Employee.fromJson(Map<String, dynamic> json){
    position = json['position'];
    fullname = json['fullname'];
    salaryrate = json['salaryrate'];
    geolocation = json['geolocation'];
    id = json['id'];
  }
}
