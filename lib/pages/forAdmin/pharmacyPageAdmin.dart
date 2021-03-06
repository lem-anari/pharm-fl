import 'dart:convert';

import 'package:farma_app/domain/pharmacy.dart';
import 'package:farma_app/domain/all_productsInPharmacy.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PharmacyPageAdmin extends StatefulWidget {
  const PharmacyPageAdmin({Key key}) : super(key: key);

  @override
  _PharmacyPageAdminState createState() => _PharmacyPageAdminState();
}

class _PharmacyPageAdminState extends State<PharmacyPageAdmin> {
  int sectionIndexPharmacy = 0;
  SharedPreferences sharedPreferences;
  String nameP;
  int id;
  String nameProductCurrent;
  var filterHeight = 0.0;
  var heightAddPharm = 0.0;
  var addAmount = '';
  var addPrice = '';
  var addNamePharm = '';
  var addAddress = '';
  var filterPriceController = TextEditingController();
  var filterAmountController = TextEditingController();
  var namePharmController = TextEditingController();
  var addressController = TextEditingController();
  var filterText = '';

  List<Pharmacy> _pharmacies = List<Pharmacy>();

  Future <List<Pharmacy>> fetchPharmacies() async {
    var response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/pharm/all_pharmacies"));
    var pharmacies = List<Pharmacy>();
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> pharmaciesJson = map["pharmacies"];
      print(pharmaciesJson[0]["nameofpharm"]);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      for (var pharmacyJson in pharmaciesJson) {
        pharmacies.add(Pharmacy.fromJson(pharmacyJson));
      }
    }
    return pharmacies;
  }

  List<AllProductsInPharmacy> _productsInPharmacy = List<AllProductsInPharmacy>();

  Future <List<AllProductsInPharmacy>> fetchProductsInPharmacy(
      int idSupply) async {
    Map data = {
      'pharmacy_id': idSupply.toString()
    };
    var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/supply/all_suppliesInPharmaId"),
        body: data);
    var nameProducts = List<AllProductsInPharmacy>();

    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> productsJson = map["supplyProductsName"];
      print("here error");
      print(productsJson[0]);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

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
    return nameProducts;
  }

  setSupplyProduct(String namePharm, nameProd, price, amount) async {
    Map supply = {
      'nameofpharm': namePharm,
      'nameofproduct': nameProd,
      'priceofproduct': price,
      'amountofproduct': amount,
    };
    var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/supply/set_supply"), body: supply);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Fluttertoast.showToast(
          msg: "??????????????????!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0);
      if (jsonResponse != null) {
        setState(() {});
      }
    }else {
      setState(() {});
      print('response error: ${response.body}');
    }
  }
  addPharmacy(String namePharm, address) async {
    Map body = {
      'nameofpharm': namePharm,
      'addressofpharm': address,
    };
    var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/pharm/add_pharmacy"), body: body);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Fluttertoast.showToast(
          msg: "???????????? ??????????????????!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0);
      if (jsonResponse != null) {
        setState(() {});
      }
    }else {
      setState(() {});
      print('response error: ${response.body}');
    }
  }

    @override
    void initState() {
      fetchPharmacies().then((value) {
        setState(() {
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
                              decoration: const InputDecoration(
                                  labelText: 'Price'),
                              onChanged: (String val) =>
                                  setState(() => addPrice = val),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child:
                            TextFormField(
                              controller: filterAmountController,
                              decoration: const InputDecoration(
                                  labelText: 'Amount'),
                              onChanged: (String val) =>
                                  setState(() => addAmount = val),
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
                              setSupplyProduct(nameP, nameProductCurrent, addPrice,addAmount);
                            },
                            child:
                            Text(
                                "Apply", style: TextStyle(color: Colors.white)),
                            color: Theme
                                .of(context)
                                .primaryColor,
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
                            Text(
                                "Clear", style: TextStyle(color: Colors.white)),
                            color: Colors.red,
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      flex: 1,
                      child:
                      Text(nameProductCurrent ?? 'current product name',
                          style: TextStyle(color: Colors.black)),
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
        child: (sectionIndexPharmacy == 0)
            ?
        Column(
          children: [
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
                                controller: namePharmController,
                                decoration: const InputDecoration(
                                    labelText: '????????????????'),
                                onChanged: (String val) =>
                                    setState(() => addNamePharm = val),
                              ),

                            ),
                            SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child:
                              TextFormField(
                                controller: addressController,
                                decoration: const InputDecoration(
                                    labelText: '??????????'),
                                onChanged: (String val) =>
                                    setState(() => addAddress = val),
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
                                print('SAVE');
                                addPharmacy(addNamePharm, addAddress);
                              },
                              child:
                              Text(
                                  "??????????????????", style: TextStyle(color: Colors.white)),
                              color: Theme
                                  .of(context)
                                  .primaryColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: RaisedButton(
                              onPressed: () {
                                namePharmController.clear();
                                addressController.clear();
//                                  filterHeight = 0.0;
                              //////////////////
                              },
                              child:
                              Text(
                                  "????????????????", style: TextStyle(color: Colors.white)),
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              height: heightAddPharm,
            ),

            Expanded(
                child:

                ListView.builder(
                    itemCount: _pharmacies.length,
                    itemBuilder: (context, i) {
                      return Card(
                          elevation: 2.0,
                          margin: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Container(
                            decoration:
                            BoxDecoration(color: Color.fromRGBO(230, 230, 250,
                                0.95)),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10),
                              leading: Container(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(Icons.local_pharmacy_outlined,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline6
                                        .color),
                                decoration: BoxDecoration(
                                    border: Border(
                                        right:
                                        BorderSide(
                                            width: 1, color: Colors.white24))),
                              ),
                              title: Text(_pharmacies[i].nameofpharm,
                                  style: TextStyle(
                                      color: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6
                                          .color,
                                      fontWeight: FontWeight.bold)),
                              trailing:
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_right,
                                    color: Theme
                                        .of(context)
                                        .textTheme
                                        .headline6
                                        .color),
                                onPressed: () {
                                  setState(() =>
                                  {
                                    sectionIndexPharmacy = 1,
                                    nameP = _pharmacies[i].nameofpharm,
                                    id = _pharmacies[i].id,
                                    print(id),
                                    print("THERE ARE NAMES OF PRODUCT'S"),
                                    fetchProductsInPharmacy(id).then((value) {
                                      setState(() {
                                        _productsInPharmacy.clear();
                                        _productsInPharmacy.addAll(value);
                                      });
                                    })
                                  });
                                },
                              ),
                            ),
                          ));
                    })
            ),
            Row(
              children: [
                SizedBox(width:300),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.pinkAccent[400],
                      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                  padding: EdgeInsets.only(top: 7, bottom: 7),
                      textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal)),

                  onPressed: () {
                    setState(() {
                      heightAddPharm = (heightAddPharm == 0.0 ? 150.0 : 0.0);
                    });
                  },
//              child: const Text('???????????????? ????????????'),
                  child: const Icon(Icons.add_circle, size: 36,),
                ),

              ],
            ),
            SizedBox(height:16),
          ],
        )
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
                        color: Theme
                            .of(context)
                            .textTheme
                            .headline6
                            .color),
                    decoration: BoxDecoration(
                        border: Border(
                            right:
                            BorderSide(width: 1, color: Colors.white24))),
                  ),
                  title: Text(nameP,
                      style: TextStyle(
                          color: Theme
                              .of(context)
                              .textTheme
                              .headline6
                              .color,
                          fontWeight: FontWeight.bold)),
                  trailing:
                  IconButton(
                    icon: Icon(Icons.close_rounded,
                        color: Theme
                            .of(context)
                            .textTheme
                            .headline6
                            .color),
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
                            margin: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: Column(
                              children: [
                                Container(
                                  decoration:
//                              BoxDecoration(color: Color.fromRGBO(50, 65, 85, 0.9)),
                                  BoxDecoration(color: Color.fromRGBO(
                                      230, 230, 250, 0.95)),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10),
                                    leading: Container(
                                      padding: EdgeInsets.only(right: 12),
                                      child: Icon(Icons.bubble_chart_outlined,
                                          color: Theme
                                              .of(context)
                                              .textTheme
                                              .headline6
                                              .color),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              right:
                                              BorderSide(width: 1,
                                                  color: Colors.white24))),
                                    ),
                                    title: Text(
                                        _productsInPharmacy[j].nameofproduct,
                                        style: TextStyle(
                                            color: Theme
                                                .of(context)
                                                .textTheme
                                                .headline6
                                                .color,
                                            fontWeight: FontWeight.bold)),
                                    trailing:
                                    IconButton(
                                      icon: Icon(
                                          Icons.add_circle_outline_rounded,
                                          color: Theme
                                              .of(context)
                                              .textTheme
                                              .headline6
                                              .color),
                                      onPressed: () {
                                        setState(() =>
                                        {

                                          nameProductCurrent =
                                              _productsInPharmacy[j].nameofproduct,
                                          filterHeight =
                                          (filterHeight == 0.0 ? 180.0 : 0.0),

                                        });
                                      },
                                    ),
                                  ),
                                ),

                              ],
                            )
                        );
                    }),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.pinkAccent[400],
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal)),
                onPressed: () {
                  setState(() {
//                  addPharmacy();
//                    heightAddPharm = (heightAddPharm == 0.0 ? 150.0 : 0.0);
                  });
                },
                child: const Text('???????????????? ??????????????'),
              ),
            ]),
      );
    }
  }
