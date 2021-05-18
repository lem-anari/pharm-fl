import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:farma_app/domain/audit.dart';


class AuditsPage extends StatefulWidget {
  @override
  _AuditsPageState createState() => _AuditsPageState();
}

class _AuditsPageState extends State<AuditsPage> {

  SharedPreferences sharedPreferences;

  List<Audit> _userAudits = List<Audit>();

  Future <List<Audit>> fetchUserAudits() async{
    sharedPreferences = await SharedPreferences.getInstance();
    String UId =  sharedPreferences.getString("user_id");
    Map data = {
      'user_id': UId.toString()
    };
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/auditEmployee/auditsOfEmployee"), body: data);
    var audits = List<Audit>();

    if(response.statusCode == 200) {

      Map<String, dynamic> map = json.decode(response.body);
      Map<String, dynamic> auditsJson = map["auditUser"];

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      for(var auditJson in auditsJson.entries){
        audits.add(Audit.fromJson(auditJson.value));
      }
    }
    print(audits.length);

    return audits;
  }


  List<AuditPharmName> _pharmNameAudits = List<AuditPharmName>();
  Future <List<AuditPharmName>> fetchAuditPharmNames() async{
    sharedPreferences = await SharedPreferences.getInstance();
    String UId =  sharedPreferences.getString("user_id");
    Map data = {
      'user_id': UId.toString()
    };
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/auditEmployee/auditsOfEmployee"), body: data);
    var auditPharmNames = List<AuditPharmName>();
    if(response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List< dynamic> pharmNamesJson = map["pharm"];

      print(pharmNamesJson);
      for(var pharmNameJson in pharmNamesJson){
        auditPharmNames.add(AuditPharmName.fromJsonPharm(pharmNameJson));
      }
    }
    print(auditPharmNames.length);
    return auditPharmNames;
  }

  @override
  void initState(){
    fetchUserAudits().then((value) {
      setState((){
        _userAudits.addAll(value);
      });
    });
    fetchAuditPharmNames().then((value) {
      setState((){
        _pharmNameAudits.addAll(value);
      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

//    return Container();
//    getUserAudits();
//  var lengthAudit = _userAudits.length /2;
    var workoutsList = Expanded(
      child: ListView.builder(
//          itemCount: lengthAudit.toInt(),
          itemCount: _userAudits.length,
          itemBuilder: (context, i) {
            return Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Container(
                decoration:
                BoxDecoration( color:_userAudits[i].delay
                    ?  Color.fromRGBO(252, 100, 64, 0.9)
//                    ?  Color.fromRGBO(30, 55, 105, 0.9)
                    : Color.fromRGBO(230, 230, 250, 0.95)),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(  _userAudits[i].delegate
                        ? Icons.person_outline_sharp
                        : Icons.person_remove_outlined,
                        color: Theme.of(context).textTheme.headline6.color),
                    decoration: BoxDecoration(
                        border: Border(
                            right:
                            BorderSide(width: 1, color: Colors.white24))),
                  ),
                  title: Text(_pharmNameAudits[i].pharmacy,
//                    title: Text((i == 0) ? _userAudits[(i+1)*3].pharmacy : _userAudits[(i+1)*3 -4].pharmacy,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                          fontWeight: FontWeight.bold)),
                  trailing: Icon(Icons.subdirectory_arrow_right_outlined,
                      color: Theme.of(context).textTheme.headline6.color),
//                  subtitle: subtitle(context, _userAudits[i]),
                  subtitle: Text(_userAudits[i].dateandtime,
//                    title: Text((i == 0) ? _userAudits[(i+1)*3].pharmacy : _userAudits[(i+1)*3 -4].pharmacy,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                          fontWeight: FontWeight.normal)),
                ),
              ),
            );
          }),
    );





    return Column(
      children: <Widget>[
        workoutsList,
      ],
    );
  }
}
