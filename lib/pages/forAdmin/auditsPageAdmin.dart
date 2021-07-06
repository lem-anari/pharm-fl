import 'dart:convert';

import 'package:farma_app/domain/employee.dart';
import 'package:farma_app/domain/pharmacy.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:farma_app/domain/audit.dart';
import 'package:intl/intl.dart';


class AuditsPageAdmin extends StatefulWidget {
  @override
  _AuditsPageAdminState createState() => _AuditsPageAdminState();
}

class _AuditsPageAdminState extends State<AuditsPageAdmin> {
  var menuHeight = 0.0;
  var menuTextName = '';
  var auditId;
  var menuTextTime = '';
  var iconMenu = true;
  var heightAddAudit = 0.0;
  var heightDoneAudit = 0.0;
  var heightDelayAudit = 0.0;
  var heightPlanAudit = 0.0;
  String pharmaciesList;
  String employeesList;
  String timesList;
  String datesList;
  var timeArray = ['09:00', '09:30', '10:00', '10:30', '11:00', '11:30', '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
    '15:00', '15:30', '16:00', '16:30', '17:00', '17:30', '18:00', '18:30', '19:00', '19:30', '20:00'];

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  List<List<String>> getDaysForRange(DateTime start, DateTime end) {
    var result = List<List<String>>();
    var date = start;
    var day = List<String>();
    while(date.difference(end).inDays <= 0) {
      day.add(convertDateTimeDisplay(date.toString()));
      date = date.add(const Duration(days: 1));
    }
    result.add(day);
    return result;
  }


//  var addAmount = '';
//  var addPrice = '';
//  var addNamePharm = '';
//  var addAddress = '';
//  var filterPriceController = TextEditingController();

  SharedPreferences sharedPreferences;

  List<Pharmacy> _getInfoPharmacyForNewAudit = List<Pharmacy>();
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
  List<Employee> _getInfoEmployeeForNewAudit = List<Employee>();
  Future <List<Employee>> fetchEmployees() async {
    var response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/employee/all_employees"));
    var employees = List<Employee>();
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> employeesJson = map["employees"];
//      print(pharmaciesJson[0]["nameofpharm"]);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      for (var employeeJson in employeesJson) {
        employees.add(Employee.fromJson(employeeJson));
      }
    }
    return employees;
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
  addAuditAdmin(String namePharm, nameEmployee, date, time) async {
    Map body = {
      'nameofpharm': namePharm,
      'nameEmployee': nameEmployee,
      'date': date,
      'time': time,
    };
    var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/audit/createAudit"), body: body);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      Fluttertoast.showToast(
          msg: "Аудит добавлен!",
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
      Fluttertoast.showToast(
          msg: "Ошибка добавления!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      print('response error: ${response.body}');
    }
  }
  List<AuditDone> _doneAudits = List<AuditDone>();
  Future <List<AuditDone>> fetchDoneAudit() async{

    var response = await http.get(Uri.parse("http://10.0.2.2:8000/api/audit/doneAudit"));
    print('responseeeeeeeeeeeeeeeeeeeeeee');
    var doneAudits = List<AuditDone>();
    if(response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> map = json.decode(response.body);

      Map<String, dynamic> donesJson = map["doneAudits"];

      for(var doneJson in donesJson.values){
        doneAudits.add(AuditDone.fromJson(doneJson));
      }
    }
//    print(doneAudits);
    return doneAudits;
  }

  List<AuditDelay> _delayAudits = List<AuditDelay>();
  Future <List<AuditDelay>> fetchDelayAudit() async{

    var response = await http.get(Uri.parse("http://10.0.2.2:8000/api/audit/delayAudit"));
    print('responseeeeeeeeeeeeeeeeeeeeeee');
    var doneAudits = List<AuditDelay>();
    if(response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> map = json.decode(response.body);

      Map<String, dynamic> donesJson = map["delayAudits"];

      for(var doneJson in donesJson.values){
        doneAudits.add(AuditDelay.fromJson(doneJson));
      }
    }
//    print(doneAudits);
    return doneAudits;
  }

  List<AuditPlan> _planAudits = List<AuditPlan>();
  Future <List<AuditPlan>> fetchPlanAudit() async{

    var response = await http.get(Uri.parse("http://10.0.2.2:8000/api/audit/planAudit"));
    print('responseeeeeeeeeeeeeeeeeeeeeee');
    var doneAudits = List<AuditPlan>();
    if(response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> map = json.decode(response.body);

      Map<String, dynamic> donesJson = map["planAudits"];

      for(var doneJson in donesJson.values){
        doneAudits.add(AuditPlan.fromJson(doneJson));
      }
    }
    return doneAudits;
  }

  @override
  void initState(){
    fetchPharmacies().then((value) {
      setState(() {
        _getInfoPharmacyForNewAudit.addAll(value);
      });
    });
    fetchEmployees().then((value) {
      setState(() {
        _getInfoEmployeeForNewAudit.addAll(value);
      });
    });
    fetchDelayAudit().then((value) {
      setState(() {
        _delayAudits.addAll(value);
      });
    });
    fetchPlanAudit().then((value) {
      setState(() {
        _planAudits.addAll(value);
      });
    });
//    fetchUserAudits().then((value) {
//      setState((){
//        _userAudits.addAll(value);
//      });
//    });
    fetchAuditPharmNames().then((value) {
      setState((){
        _pharmNameAudits.addAll(value);
      });
    });
    fetchDoneAudit().then((value) {
      setState((){
        _doneAudits.addAll(value);
      });
    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

//    print(formattedDate);
    var days = getDaysForRange(DateTime.utc(DateTime.now().year,DateTime.now().month,DateTime.now().day), DateTime.utc(DateTime.now().year,DateTime.now().month+1,DateTime.now().day));

    print(days);
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
    var doneAuditsList = SingleChildScrollView(
        child: Column(children: [
          AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Expanded(
          child:Card(
    child: Padding(
    padding: const EdgeInsets.all(8.0),
        child: Column(
    children: [
      Expanded(
        child:
      ListView.builder(
          itemCount: _doneAudits.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                Card(
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Container(
                    decoration:
                    BoxDecoration(color:Colors.green[400]
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12),
//                        child: Icon(_doneAudits[i].delay
                            child: Icon(true
                            ? Icons.person_outline_sharp
                            : null,
                            color: Theme.of(context).textTheme.headline6.color),
                        decoration: BoxDecoration(
                            border: Border(
                                right:
                                BorderSide(width: 1, color: Colors.white24))),
                      ),
                      title: Text(_doneAudits[i].dateandtime),
//                    title: Text((i == 0) ? _userAudits[(i+1)*3].pharmacy : _userAudits[(i+1)*3 -4].pharmacy,
//                          style: TextStyle(
//                              color: Theme.of(context).textTheme.headline6.color,
//                              fontWeight: FontWeight.bold)),
                      trailing: GestureDetector(
                        child: (iconMenu == true)
                            ? Icon(Icons.menu_open, color: Colors.black87)
                            : Icon(Icons.menu_open, color: Colors.black87),
                        onTap: () {
                          setState(() {
                            print('OPEN MENU');
                          });
                        },
                      ),
                      subtitle: Text(_doneAudits[i].dateandtime,
                          style: TextStyle(
                              color: Theme.of(context).textTheme.headline6.color,
                              fontWeight: FontWeight.normal)),
                    ),
                  ),
                ),
              ],);
          })
      )
    ]),
    ))),
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        height: heightDoneAudit
    )]));
    var delayAuditsList = SingleChildScrollView(
        child: Column(children: [
          AnimatedContainer(
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
              child: Expanded(
                  child:Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            children: [
                              Expanded(
                                  child:
                                  ListView.builder(
                                      itemCount: _delayAudits.length,
                                      itemBuilder: (context, i) {
                                        return Column(
                                          children: [
                                            Card(
                                              elevation: 2.0,
                                              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              child: Container(
                                                decoration:
                                                BoxDecoration(color:Colors.red[400]
                                                ),
                                                child: ListTile(
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                  leading: Container(
                                                    padding: EdgeInsets.only(right: 12),
//                        child: Icon(_doneAudits[i].delay
                                                    child: Icon(true
                                                        ? Icons.person_outline_sharp
                                                        : null,
                                                        color: Theme.of(context).textTheme.headline6.color),
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            right:
                                                            BorderSide(width: 1, color: Colors.white24))),
                                                  ),
                                                  title: Text(_delayAudits[i].dateandtime),
                                                  trailing: GestureDetector(
                                                    child: (iconMenu == true)
                                                        ? Icon(Icons.menu_open, color: Colors.black87)
                                                        : Icon(Icons.menu_open, color: Colors.black87),
                                                    onTap: () {
                                                      setState(() {
                                                        print('OPEN MENU');
                                                      });
                                                    },
                                                  ),
                                                  subtitle: Text(_delayAudits[i].dateandtime,
                                                      style: TextStyle(
                                                          color: Theme.of(context).textTheme.headline6.color,
                                                          fontWeight: FontWeight.normal)),
                                                ),
                                              ),
                                            ),
                                          ],);
                                      })
                              )
                            ]),
                      ))),
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              height: heightDelayAudit
          )]));

    var planAuditsList = SingleChildScrollView(
        child: Column(children: [
          AnimatedContainer(
              margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
              child: Expanded(
                  child:Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            children: [
                              Expanded(
                                  child:
                                  ListView.builder(
                                      itemCount: _planAudits.length,
                                      itemBuilder: (context, i) {
                                        return Column(
                                          children: [
                                            Card(
                                              elevation: 2.0,
                                              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              child: Container(
                                                decoration:
                                                BoxDecoration(color:Colors.blueGrey[400]
                                                ),
                                                child: ListTile(
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                                  leading: Container(
                                                    padding: EdgeInsets.only(right: 12),
//                        child: Icon(_doneAudits[i].delay
                                                    child: Icon(true
                                                        ? Icons.person_outline_sharp
                                                        : null,
                                                        color: Theme.of(context).textTheme.headline6.color),
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            right:
                                                            BorderSide(width: 1, color: Colors.white24))),
                                                  ),
                                                  title: Text(_planAudits[i].dateandtime),
                                                  trailing: GestureDetector(
                                                    child: (iconMenu == true)
                                                        ? Icon(Icons.menu_open, color: Colors.black87)
                                                        : Icon(Icons.menu_open, color: Colors.black87),
                                                    onTap: () {
                                                      setState(() {
                                                        print('OPEN MENU');
                                                      });
                                                    },
                                                  ),
                                                  subtitle: Text(_planAudits[i].dateandtime,
                                                      style: TextStyle(
                                                          color: Theme.of(context).textTheme.headline6.color,
                                                          fontWeight: FontWeight.normal)),
                                                ),
                                              ),
                                            ),
                                          ],);
                                      })
                              )
                            ]),
                      ))),
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastOutSlowIn,
              height: heightPlanAudit
          )]));

    var addAudit = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
                    Expanded(
                      flex: 1,
                      child: DropdownButton(
                        hint: pharmaciesList == null
                            ? Text('Выберите аптеку')
                            : Text(
                          pharmaciesList,
                          style: TextStyle(color: Colors.blue),
                        ),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: TextStyle(color: Colors.blue),
                        items: _getInfoPharmacyForNewAudit.map(
                              (val) {
                            return DropdownMenuItem<Pharmacy>(
                              value: val,
                              child: Text(val.nameofpharm),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(
                                () {
                              print(val.nameofpharm);
                              pharmaciesList = val.nameofpharm;
                            },
                          );
                        },
                      ),
                    ),
            Expanded(
              flex: 1,
              child: DropdownButton(
                hint: employeesList == null
                    ? Text('Выберите сотрудника')
                    : Text(
                  employeesList,
                  style: TextStyle(color: Colors.blue),
                ),
                isExpanded: true,
                iconSize: 30.0,
                style: TextStyle(color: Colors.blue),
                items: _getInfoEmployeeForNewAudit.map(
                      (val) {
                    return DropdownMenuItem<Employee>(
                      value: val,
                      child: Text(val.fullname),
//                              child: Text('namemem'),
                    );
                  },
                ).toList(),
                onChanged: (val) {
                  setState(
                        () {
                      print(val.fullname);
                      employeesList = val.fullname;
                    },
                  );
                },
              ),
            ),
              Row(
                children: [
              Expanded(
                flex: 1,
                child: DropdownButton(
                  hint: datesList == null
                      ? Text('Выберите дату')
                      : Text(
                    datesList,
                    style: TextStyle(color: Colors.blue),
                  ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: TextStyle(color: Colors.blue),
                  items: days[0].map(
                        (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(
                          () {
                        print(val);
                        datesList = val;
                      },
                    );
                  },
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: DropdownButton(
                  hint: timesList == null
                      ? Text('Выберите время')
                      : Text(
                    timesList,
                    style: TextStyle(color: Colors.blue),
                  ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: TextStyle(color: Colors.blue),
                  items: timeArray.map(
                        (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState(() {
                        print(val);
                        timesList = val;
                      },
                    );
                  },
                ),
              ),
                ]),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {
                        print('SAVE');
                        addAuditAdmin(pharmaciesList, employeesList, datesList, timesList);
                      },
                      child:
                      Text(
                          "Сохранить", style: TextStyle(color: Colors.white)),
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
                        setState(() {
                          pharmaciesList = 'Выберите аптеку';
                              employeesList = 'Выберите сотрудника';
                              datesList = 'Выберите дату';
                              timesList = 'Выберите время';
                          },
                        );
                      },

                      child:
                      Text(
                          "Сбросить", style: TextStyle(color: Colors.white)),
                      color: Colors.pink,
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
      height: heightAddAudit,
    );

    var auditActionButtons = Container(
      child: Column(
      children: [

        Row(
          children: [
            SizedBox(width: 15),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.pinkAccent[400],
//              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal)),
          onPressed: () {
            setState(() {
//                  addPharmacy();
            print('_doneAudits.length ${_doneAudits.length}');
              heightDoneAudit = (heightDoneAudit == 0.0 ? 500.0 : 0.0);
              //how to know the size

            });
          },
          child: Icon(Icons.check_circle),
        ),
        SizedBox(width: 35),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.pinkAccent[400],
//              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal)),
          onPressed: () {
            setState(() {
                    heightDelayAudit = (heightDelayAudit == 0.0 ? 500.0 : 0.0);
            });
          },
          child: Icon(Icons.close_rounded),
        ),
            SizedBox(width: 35),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.pinkAccent[400],
//              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal)),
              onPressed: () {
                setState(() {
                  heightPlanAudit = (heightPlanAudit == 0.0 ? 500.0 : 0.0);
                });
              },
              child: Icon(Icons.timelapse_sharp),
            ),
            SizedBox(width: 35),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.pinkAccent[400],
//              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal)),
          onPressed: () {
            setState(() {
//                  addPharmacy();
                    heightAddAudit = (heightAddAudit == 0.0 ? 190.0 : 0.0);
            });
          },
//          child: const Text('Добавить'),
          child: const Icon(Icons.add_circle),
        ),],
        ),
        doneAuditsList,
        addAudit,
        delayAuditsList,
        planAuditsList
              ]));



    return Column(
      children: <Widget>[
//        showDetailAuditMenu,
//        workoutsList,
        auditActionButtons
      ],
    );
  }

//  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
