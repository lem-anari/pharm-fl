class Pharmacy {
  String nameofpharm;
  String addressofpharm;

  Pharmacy({this.nameofpharm, this.addressofpharm});//without {}
  Pharmacy.fromJson(Map<String, dynamic> json){
    nameofpharm = json['nameofpharm'];
    addressofpharm = json['addressofpharm'];
  }
}
