import 'dart:convert';

import 'package:farma_app/domain/pharmacy.dart';
import 'package:farma_app/domain/all_productsInPharmacy.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PharmacyPage extends StatefulWidget {
//  const PharmacyPage({Key key}) : super(key: key);

  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  int sectionIndexPharmacy = 0;
  SharedPreferences sharedPreferences;
  String nameP;
  int id;
  String nameProductCurrent;
  var filterHeight = 0.0;
  var addAmount = '';
  var addPrice = '';
  var filterPriceController = TextEditingController();
  var filterAmountController = TextEditingController();
  var filterText = '';



  List<Pharmacy> _pharmacies = List<Pharmacy>();
  Future <List<Pharmacy>> fetchPharmacies() async{
    var response = await http.get(Uri.parse("http://10.0.2.2:8000/api/pharm/all_pharmacies"));
    var pharmacies = List<Pharmacy>();
    if(response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> pharmaciesJson = map["pharmacies"];
      print(pharmaciesJson[0]["nameofpharm"]);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      for(var pharmacyJson in pharmaciesJson){
        pharmacies.add(Pharmacy.fromJson(pharmacyJson));
      }
    }
    return pharmacies;
  }

  List<AllProductsInPharmacy> _productsInPharmacy = List<AllProductsInPharmacy>();

  Future <List<AllProductsInPharmacy>> fetchProductsInPharmacy(int idSupply) async{
    Map data = {
      'pharmacy_id': idSupply.toString()
    };
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/supply/all_suppliesInPharmaId"), body: data);
    var nameProducts = List<AllProductsInPharmacy>();

    if(response.statusCode == 200) {

      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> productsJson = map["supplyProductsName"];
      print("here error");
      print(productsJson.length);
//      print(productsJson[0]);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(productsJson.length != 0){
        bool matched = false;
        for (var productJson in productsJson) {
          print('wriiiite: ${productJson}');
          for(int a=0; a<nameProducts.length; a++){
            if(nameProducts[a].nameofproduct == productJson[0]){
              matched = true;
            }
          }
          if(matched == false){
            nameProducts.add(AllProductsInPharmacy.fromJson(productJson));
          }

        }
      }


    }
    return nameProducts;
  }

  setApplyProduct(String namePharm, nameProd, price, amount) async {
    DateTime currentTime = DateTime.now().toLocal();

    sharedPreferences = await SharedPreferences.getInstance();
    var emp_id = sharedPreferences.getString("employee_id");
//    print('TIME ${currentTime}');
    print('TIME ${DateTime.parse('${currentTime}-03:00')}');
    Map audit_time = {
      'currentTime': DateTime.parse('${currentTime}-03:00').toString(),
      'namePharm' : namePharm,
      'emp_id' : emp_id
    };
    var responseCurrentTimeAudit = await http.post(Uri.parse("http://10.0.2.2:8000/api/audit/get_audit_dateTime"), body: audit_time);
    var jsonResponse = null;
    var jsonResponseTime = null;
    print('namePharm${namePharm}');
    print('nameofproduct${nameProd}');
    print('priceofproduct${price}');
    print('amountofproduct${amount}');
    if(responseCurrentTimeAudit.statusCode == 200){
      jsonResponseTime = json.decode(responseCurrentTimeAudit.body);
      Map<String, dynamic> map = json.decode(responseCurrentTimeAudit.body);
//      print(responseCurrentTimeAudit.body);
      String pharmNameJson = map["pharm_name"];
//      print('PHARM NAME ${pharmNameJson}');
//      print('PHARM NAME ${namePharm}');
      if(pharmNameJson == namePharm){
        Map<String,dynamic> currauditTimeJson = map["auditDateTime"];
        Map data = {
          'nameofpharm': namePharm,
          'nameofproduct': nameProd,
          'priceofproduct': price,
          'amountofproduct': amount,
          'audit_id' : currauditTimeJson['id'].toString()
        };
        print('YOU CAN DO PURCHASE');
        var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/purchases/setPurchase"), body: data);
        if(jsonResponseTime != null) {
          setState(() {});
          if(response.statusCode == 200) {
            jsonResponse = json.decode(response.body);
            print('Response status: ${response.statusCode}');
            print('Response body: ${response.body}');
            if(jsonResponse != null) {
              setState(() {});
            }else {
              setState(() {});
              print(response.body);

            }
          }
          }
        }
        else {
          setState(() {});
        }
      Fluttertoast.showToast(
          msg: "Успешно заполнено!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0);
      }else{
        setState(() {});
        Fluttertoast.showToast(
            msg: "Вы не можете вносить данные вне время аудита",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
//        print('responseCurrentTimeAudit.body${responseCurrentTimeAudit.body}');
    }
  }

  @override
  void initState(){
    fetchPharmacies().then((value) {
      setState((){
      _pharmacies.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var addPurchaseForm = SingleChildScrollView(
            child: Column(children: [
            AnimatedContainer(
            margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                    Row(
                    children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: filterPriceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        onChanged: (String val) => setState(() => addPrice = val),
                      ),

                    ),
                      SizedBox(width: 20),
                    Expanded(
                        flex: 1,
                        child:
                      TextFormField(
                        controller: filterAmountController,
                        decoration: const InputDecoration(labelText: 'Amount'),
                        onChanged: (String val) => setState(() => addAmount = val),
                      ),
                    ),
                    ]),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: RaisedButton(
                                onPressed: () {
                                  print('APPLY');
                                  setApplyProduct(nameP, nameProductCurrent, addPrice, addAmount);
                                },
                                child:
                                Text("Apply", style: TextStyle(color: Colors.white)),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: RaisedButton(
                                onPressed: () {
                                  filterAmountController.clear();
                                  filterPriceController.clear();
//                                  filterHeight = 0.0;
                                },
                                child:
                                Text("Clear", style: TextStyle(color: Colors.white)),
                                color: Colors.red,
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          flex: 1,
                          child:
                          Text(nameProductCurrent??'current product name', style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                ),
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                height: filterHeight,
              )
            ]),
          );



    return Container(
      child: (sectionIndexPharmacy  == 0)
        ?
      ListView.builder(
        itemCount: _pharmacies.length,
        itemBuilder: (context, i) {
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              decoration:
//              BoxDecoration(color: Color.fromRGBO(50, 65, 85, 0.9)),
//              BoxDecoration(color: Color.fromRGBO(20, 60, 110, 0.83)),
                BoxDecoration(color: Color.fromRGBO(230, 230, 250, 0.95)),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                leading: Container(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.local_pharmacy_outlined,
                      color: Theme.of(context).textTheme.headline6.color),
                  decoration: BoxDecoration(
                      border: Border(
                          right:
                          BorderSide(width: 1, color: Colors.white24))),
                ),
                title: Text(_pharmacies[i].nameofpharm,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline6.color,
                        fontWeight: FontWeight.bold)),
                trailing:
                      IconButton(
                      icon: Icon(Icons.keyboard_arrow_right,
                          color: Theme.of(context).textTheme.headline6.color),
                      onPressed: () {
                        setState(() => {
                          sectionIndexPharmacy = 1, nameP = _pharmacies[i].nameofpharm, id = _pharmacies[i].id, print(id),
                        print("THERE ARE NAMES OF PRODUCT'S"),
                        fetchProductsInPharmacy(id).then((value) {
                              setState((){
                                _productsInPharmacy.clear();
                                _productsInPharmacy.addAll(value);
                              });
                        })
                        });
//                        get_suppliesProducts(id);
//                        print("THERE ARE NAMES OF PRODUCT'S");
//                        print(nameProducts.length);

                      },
                    ),
            ),
          ));
        })
      :
      Column(
          children: [
            Container(
              decoration:
//              BoxDecoration(color: Color.fromRGBO(50, 65, 85, 0.9)),
              BoxDecoration(color: Color.fromRGBO(250, 240, 250, 0.85)),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                leading: Container(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.local_pharmacy_outlined,
                      color: Theme.of(context).textTheme.headline6.color),
                  decoration: BoxDecoration(
                      border: Border(
                          right:
                          BorderSide(width: 1, color: Colors.white24))),
                ),
                title: Text(nameP,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline6.color,
                        fontWeight: FontWeight.bold)),
                trailing:
                IconButton(
                  icon: Icon(Icons.close_rounded,
                      color: Theme.of(context).textTheme.headline6.color),
                  onPressed: () {
                    setState(() => {sectionIndexPharmacy = 0});
                  },
                ),
              ),
            ),


            addPurchaseForm,
    Expanded(
    child:
    ListView.builder(
                itemCount: _productsInPharmacy.length,
                itemBuilder: (context, j) {
                  return
                    Card(
                        elevation: 2.0,
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Column(
                          children: [



                            Container(
                              decoration:
//                              BoxDecoration(color: Color.fromRGBO(50, 65, 85, 0.9)),
                              BoxDecoration(color: Color.fromRGBO(230, 230, 250, 0.95)),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 12),
                                  child: Icon(Icons.bubble_chart_outlined,
                                      color: Theme.of(context).textTheme.headline6.color),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          right:
                                          BorderSide(width: 1, color: Colors.white24))),
                                ),
                                title: Text(_productsInPharmacy[j].nameofproduct,
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.headline6.color,
                                        fontWeight: FontWeight.bold)),
                                trailing:
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline_rounded,
                                      color: Theme.of(context).textTheme.headline6.color),
                                  onPressed: () {
                                    setState(() => {

                                      nameProductCurrent = _productsInPharmacy[j].nameofproduct,
                                      filterHeight = (filterHeight == 0.0 ? 180.0 : 0.0),

                                    });
                                  },
                                ),
                              ),
                            ),

                          ],
                        )
                    );
                }),
    )
            ]),
    );
  }
}


