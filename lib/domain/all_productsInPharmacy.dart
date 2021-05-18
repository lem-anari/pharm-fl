class AllProductsInPharmacy {
  String nameofproduct;

  AllProductsInPharmacy({this.nameofproduct});//without {}
//  AllProductsInPharmacy.fromJson(Map<String, dynamic> json){
    AllProductsInPharmacy.fromJson(List< dynamic> json){
//      nameofproduct = json['supplyProductsName'];
      nameofproduct = json[0];
//    nameofproduct = json[0]['supplyProductsName'];
  }
}
