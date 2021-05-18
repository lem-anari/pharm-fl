import 'dart:convert';

import 'package:farma_app/domain/pharmacy.dart';
import 'package:farma_app/domain/all_productsInPharmacy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PharmacyPage extends StatefulWidget {
//  const PharmacyPage({Key key}) : super(key: key);

  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  int sectionIndexPharmacy = 0;
  String nameP;
  int id;
  String nameProductCurrent;
  var filterHeight = 0.0;
  var filterTitle = '';
  var filterTitleController = TextEditingController();
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
//        print('wriiiite: ${pharmacyJson}');
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

//      print(productsJson[0]["supplyProductsName"]);
      print("here error");
      print(productsJson[0]);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      for(var productJson in productsJson){
//        print('wriiiite: ${productJson[0]}');
//        nameProducts.add(AllProductsInPharmacy.fromJson(productJson[0]));
        print('wriiiite: ${productJson}');
        nameProducts.add(AllProductsInPharmacy.fromJson(productJson));
      }
    }
    return nameProducts;
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
                        controller: filterTitleController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        onChanged: (String val) => setState(() => filterTitle = val),
                      ),

                    ),
                      SizedBox(width: 20),
                    Expanded(
                        flex: 1,
                        child:
                      TextFormField(
                        controller: filterAmountController,
                        decoration: const InputDecoration(labelText: 'Amount'),
                        onChanged: (String val) => setState(() => filterTitle = val),
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
                                  print('CLEAR');
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

//Widget subtitle(BuildContext context, Pharmacy pharmacy) {
//  var color = Colors.grey;
//  double indicatorLevel = 0;
//
//  switch (pharmacy.level) {
//    case 'Beginner':
//      color = Colors.green;
//      indicatorLevel = 0.33;
//      break;
//    case 'Intermediate':
//      color = Colors.yellow;
//      indicatorLevel = 0.66;
//      break;
//    case 'Advanced':
//      color = Colors.red;
//      indicatorLevel = 1;
//      break;
//  }

