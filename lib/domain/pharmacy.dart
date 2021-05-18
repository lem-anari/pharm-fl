class Pharmacy {
  String nameofpharm;
  String addressofpharm;
  int id;

  Pharmacy({this.nameofpharm, this.addressofpharm, this.id});//without {}
  Pharmacy.fromJson(Map<String, dynamic> json){
    nameofpharm = json['nameofpharm'];
    addressofpharm = json['addressofpharm'];
    id = json['id'];
  }
}
