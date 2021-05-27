import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:farma_app/domain/audit.dart';


class AuditsPage extends StatefulWidget {
  @override
  _AuditsPageState createState() => _AuditsPageState();
}

class _AuditsPageState extends State<AuditsPage> {
  var menuHeight = 0.0;
  var menuTextName = '';
  var auditId;
  var menuTextTime = '';
  var iconMenu = true;

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
        DateFormat d = DateFormat('yyyy-MM-dd hh:mm:ss');
        var myDate = d.parse(auditJson.value['dateandtime']);
        print('myDate${myDate}');
        print('now${DateTime.parse('${DateTime.now()}-03:00')}');
        int diffDays = myDate.difference(DateTime.now()).inDays;
        bool isSame = (diffDays == 0);
        print('is Same : ${isSame}');
        if(!isSame){
          String auditId = auditJson.value['id'].toString();
          Map data_putDelay = {
            'auditId' : auditId,
            'delay': 'true'
          };
          print(data_putDelay);
          var resp = await http.post(Uri.parse("http://10.0.2.2:8000/api/auditEmployee/putDelayAudit"), body: data_putDelay);
          print('resp status: ${resp.statusCode}');
          print('resp body: ${resp.body}');
        }
        audits.add(Audit.fromJson(auditJson.value));
      }
    }
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

      for(var pharmNameJson in pharmNamesJson){
        auditPharmNames.add(AuditPharmName.fromJsonPharm(pharmNameJson));
      }
    }
    return auditPharmNames;
  }

  setDoneAudit(int audId) async {
    Map audit_done = {
      'done': 'true',
      'audit_id' : audId.toString()
    };
    print(audId);
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/audit/set_doneAudit"), body: audit_done);

    if(response.statusCode == 200){
      Fluttertoast.showToast(
          msg: "Вы завершили аудит",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightGreen,
          textColor: Colors.white,
          fontSize: 16.0);
    }else{
      setState(() {});
    print(response.body);
    }
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
    

    var showDetailAuditMenu = Column(
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
                          child: ElevatedButton(
                            onPressed: () {
                                print('ДЕЛЕГИРОВАТЬ');
                            },
                            child: const Text('Делегировать'),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child:
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                setDoneAudit(auditId);
                                menuHeight = 0.0;
                              });
                              },

                            child: const Text('Закончить'),
                          ),
                        ),
                      ]),
                  Expanded(
                    flex: 1,
                    child:Row(
                      children: [
                        SizedBox(width: 20),
                        Text(menuTextName),
                        SizedBox(width: 20),
                        Text(menuTextTime)
                      ],
                    ),),
                ],
              ),
            ),
          ),
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          height: menuHeight,
        )
      ]);

    var workoutsList = Expanded(
      child: ListView.builder(
          itemCount: _userAudits.length,
          itemBuilder: (context, i) {
            return Column(
              children: [

              Card(
              elevation: 2.0,
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Container(
                decoration:
                BoxDecoration(color:
                (_userAudits[i].delay && _userAudits[i].done)
                    ? Colors.green[400]
                    : (_userAudits[i].delay && _userAudits[i].done == false)
                    ? Color.fromRGBO(252, 60, 64, 0.9)
                    : Color.fromRGBO(230, 240, 250, 0.95)
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(  _userAudits[i].delegate
                        ? Icons.person_outline_sharp
                        : null,
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
                  trailing: GestureDetector(
                    child: (iconMenu == true)
                        ? Icon(Icons.menu_open, color: Colors.black87)
                        : Icon(Icons.menu_open, color: Colors.black87),
                    onTap: () {
                      setState(() {
                        print('OPEN MENU');
                        iconMenu = (iconMenu == true ? false : true);
                        menuHeight = (menuHeight == 0.0 ? 100.0 : 0.0);
                        menuTextTime = _userAudits[i].dateandtime;
                        auditId = _userAudits[i].id;
                        menuTextName = _pharmNameAudits[i].pharmacy;
                      });
                    },
                  ),
//                  subtitle: subtitle(context, _userAudits[i]),
                  subtitle: Text(_userAudits[i].dateandtime,
//                    title: Text((i == 0) ? _userAudits[(i+1)*3].pharmacy : _userAudits[(i+1)*3 -4].pharmacy,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline6.color,
                          fontWeight: FontWeight.normal)),
                ),
              ),
            ),
              ],);
          }),

    );





    return Column(
      children: <Widget>[
        showDetailAuditMenu,
        workoutsList,
      ],
    );
  }
}
