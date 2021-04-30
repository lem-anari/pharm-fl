import 'dart:convert';

import 'package:farma_app/domain/pharmacy.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PharmacyPage extends StatefulWidget {
//  const PharmacyPage({Key key}) : super(key: key);

  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  List<Pharmacy> _pharmacies = List<Pharmacy>();

  Future <List<Pharmacy>> fetchPharmacies() async{
    var response = await http.get(Uri.parse("http://10.0.2.2:8000/api/pharm/all_pharmacies"));
    var pharmacies = List<Pharmacy>();

    if(response.statusCode == 200) {

      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> pharmaciesJson = map["pharmacies"];

      print(pharmaciesJson[0]["nameofpharm"]);

//      var pharmaciesJson = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      for(var pharmacyJson in pharmaciesJson){
//        print('wriiiite: ${pharmacyJson}');
        pharmacies.add(Pharmacy.fromJson(pharmacyJson));
      }
    }
    return pharmacies;
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

    return Container(
      child: ListView.builder(
        itemCount: _pharmacies.length,
        itemBuilder: (context, i) {
          return Card(
            elevation: 2.0,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              decoration:
              BoxDecoration(color: Color.fromRGBO(50, 65, 85, 0.9)),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                leading: Container(
                  padding: EdgeInsets.only(right: 12),
                  child: Icon(Icons.fitness_center,
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
                trailing: Icon(Icons.keyboard_arrow_right,
                    color: Theme.of(context).textTheme.headline6.color),
//                subtitle: subtitle(context, _pharmacies[i]),
              ),
            ),
          );
        }),
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
