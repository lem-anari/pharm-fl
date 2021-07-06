import 'dart:convert';

import 'package:farma_app/domain/employee.dart';
import 'package:farma_app/domain/pharmacy.dart';
import 'package:farma_app/domain/statistic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:farma_app/main.dart';
import 'package:farma_app/pages/loginPage.dart';
import 'package:http/http.dart' as http;

class StatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  SharedPreferences sharedPreferences;
  String userName;
  String userEmail;
  var heightStat1 = 0.0;
  var resultStatistic1Heigth = 0.0;
  var heightStat2 = 0.0;
  var resultStatistic2Heigth = 0.0;
  var heightStat3 = 0.0;
  var resultStatistic3Heigth = 0.0;
  var heightStat4 = 0.0;
  var resultStatistic4Heigth = 0.0;
  String employeesList;
  String pharmaciesList;
  String datesList;
  var resStat1;
  var resStat2;
  var resStat3;
  var resStat4;

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('MM');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  List<String> getDaysForRange(DateTime start, DateTime end) {
    var result = List<List<String>>();
    var res = List<String>();
    var date = start;
    var day = List<String>();
    while(date.difference(end).inDays <= 0) {
      day.add(convertDateTimeDisplay(date.toString()));
      date = date.add(const Duration(days: 31));
    }
    result.add(day);
    for(int a=0; a<result[0].length; a++){
      DateFormat format = DateFormat("MM");
//      print('eeeeeee ${DateFormat.MMMM().format(format.parse(result[0][a]))}');
      res.add(DateFormat.MMMM().format(format.parse(result[0][a])));
    }
    return res;
  }
  checkStat1(String nameEmployee, month) async {
    Map body = {
      'employeeFullName': nameEmployee,
      'month': month
    };
    print('nameEmployee ${nameEmployee}');
    print('month ${month}');
    var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/statistics/finesMonthEmployee"), body: body);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      int employeesJson = jsonResponse["finesEmployeeMonth"];
      print('employeesJsonemployeesJson${employeesJson}');
      resStat1 = employeesJson;

      if (jsonResponse != null) {
        setState(() {});
      }
    }else {
      setState(() {});
      Fluttertoast.showToast(
          msg: "Ошибка просмотра!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      print('response error: ${response.body}');
    }
  }
  checkStat2(String nameEmployee) async {
    Map body = {
      'employeeFullName': nameEmployee
    };
    print('nameEmployee ${nameEmployee}');
    var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/statistics/finesAllEmployee"), body: body);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      int employeesJson = jsonResponse["finesEmployeeAll"];
      print('employeesJsonemployeesJson${employeesJson}');
      resStat2 = employeesJson;

      if (jsonResponse != null) {
        setState(() {});
      }
    }else {
      setState(() {});
      Fluttertoast.showToast(
          msg: "Ошибка просмотра!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      print('response error: ${response.body}');
    }
  }
  checkStat3(String namePharm, month) async {
    Map body = {
      'nameofpharm': namePharm,
      'month' : month
    };
    print('namePharm ${namePharm}');
    var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/statistics/pharmMonth"), body: body);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      int statisticsJson = jsonResponse["pharmMonth"];
      print('statisticsJson - ${statisticsJson}');
      resStat3 = statisticsJson;

      if (jsonResponse != null) {
        setState(() {});
      }
    }else {
      setState(() {});
      Fluttertoast.showToast(
          msg: "Ошибка просмотра!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      print('response error: ${response.body}');
    }
  }
  checkStat4(String namePharm) async {
    Map body = {
      'nameofpharm': namePharm
    };
    print('namePharm ${namePharm}');
    var response = await http.post(
        Uri.parse("http://10.0.2.2:8000/api/statistics/pharmStatistic"), body: body);
    var jsonResponse = null;
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      int statisticsJson = jsonResponse["pharm"];
      print('statisticsJson - ${statisticsJson}');
      resStat4 = statisticsJson;

      if (jsonResponse != null) {
        setState(() {});
      }
    }else {
      setState(() {});
      Fluttertoast.showToast(
          msg: "Ошибка просмотра!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
      print('response error: ${response.body}');
    }
  }

  List<Employee> _getInfoEmployeeForNewAudit = List<Employee>();
  Future <List<Employee>> fetchEmployees() async {
    var response = await http.get(
        Uri.parse("http://10.0.2.2:8000/api/employee/all_employees"));
    var employees = List<Employee>();
    if (response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> employeesJson = map["employees"];
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      for (var employeeJson in employeesJson) {
        employees.add(Employee.fromJson(employeeJson));
      }
    }
    return employees;
  }
  List<Pharmacy> _getAllPharmacies = List<Pharmacy>();
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

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchStatisticNames().then((value) {
      setState((){
        _statisticNames.addAll(value);
      });
    });
    fetchPharmacies().then((value) {
      setState(() {
        _getAllPharmacies.addAll(value);
      });
    });
    fetchEmployees().then((value) {
      setState(() {
        _getInfoEmployeeForNewAudit.addAll(value);
      });
    });
  }
  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }else{
      getUserCredentials();
    }
  }
  getUserCredentials() async{
    userName =  await sharedPreferences.getString("name");
    userEmail = await sharedPreferences.getString("email");
    setState(() {
    });
  }

  List<StatisticName> _statisticNames = List<StatisticName>();
  Future <List<StatisticName>> fetchStatisticNames() async{
    var response = await http.get(Uri.parse("http://10.0.2.2:8000/api/statistics/getNames"));
    var names = List<StatisticName>();
    if(response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> namesJson = map["namesOfStatistic"];
      print("here error");
      print(namesJson[0]);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      for(var nameJson in namesJson){
        print('wriiiite: ${nameJson}');
        names.add(StatisticName.fromJson(nameJson));
      }
    }
    return names;
  }
  chooseStatistic(String name){
    switch (name) {
      case 'Представители [штрафы за месяц]':
        heightStat1 = (heightStat1 == 0.0 ? 180.0 : 0.0);
        heightStat2 = 0.0;
        heightStat3 = 0.0;
        heightStat4 = 0.0;
      break;
      case 'Представители [штрафы за всё время]':
        heightStat1 = 0.0;
        heightStat2 = (heightStat2 == 0.0 ? 110.0 : 0.0);
        heightStat3 = 0.0;
        heightStat4 = 0.0;
       break;
      case 'Продажи [аптеки за месяц]':
        heightStat1 = 0.0;
        heightStat2 = 0.0;
        heightStat3 = (heightStat3 == 0.0 ? 180.0 : 0.0);
        heightStat4 = 0.0;
        break;
      case 'Продажи [аптеки за всё время]':
        heightStat1 = 0.0;
        heightStat2 = 0.0;
        heightStat3 = 0.0;
        heightStat4 = (heightStat4 == 0.0 ? 110.0 : 0.0);
        break;
      case 'Продажи [все]':

      break;
      case 'Продажи [за год]':

      break;
      }
  }
  @override
  Widget build(BuildContext context) {
    var days = getDaysForRange(DateTime.utc(DateTime.now().year,DateTime.january,DateTime.now().day), DateTime.utc(DateTime.now().year,DateTime.now().month+1,DateTime.now().day));
    print(days);

    var bodyStatistic = Expanded(
        child:
        ListView.builder(
        itemCount: _statisticNames.length,
        itemBuilder: (context, i) {
      return
        Card(
        elevation: 2.0,
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          decoration:
          BoxDecoration(color: Color.fromRGBO(230, 230, 250, 0.95)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            leading: Container(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.stacked_line_chart,
                  color: Theme.of(context).textTheme.headline6.color),
              decoration: BoxDecoration(
                  border: Border(
                      right:
                      BorderSide(width: 1, color: Colors.white24))),
            ),
            title: Text(_statisticNames[i].name,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline6.color,
                    fontWeight: FontWeight.bold)),
            trailing:
            IconButton(
              icon: Icon(Icons.keyboard_arrow_right,
                  color: Theme.of(context).textTheme.headline6.color),
              onPressed: () {
                setState(() => {
                  chooseStatistic(_statisticNames[i].name)
                });
              },
            ),
          ),
        ));}));
    var showStat1 = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState( () {
                        print(val.fullname);
                        employeesList = val.fullname;},
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
                            ? Text('Выберите месяц')
                            : Text(
                          datesList,
                          style: TextStyle(color: Colors.blue),
                        ),
                        isExpanded: true,
                        iconSize: 30.0,
                        style: TextStyle(color: Colors.blue),
                        items: days.map(
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
                              datesList = val;
                            },
                          );
                        },
                      ),
                    ),
                  ]),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      onPressed: () {
                        print('SAVE');
                        checkStat1(employeesList, datesList);
                        resultStatistic1Heigth = 60.0;
                      },
                      child:
                      Text(
                          "Cмотреть", style: TextStyle(color: Colors.white)),
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          employeesList = 'Выберите сотрудника';
                          datesList = 'Выберите месяц';
                        },
                        );
                      },

                      child:
                      Text(
                          "Сбросить", style: TextStyle(color: Colors.white)),
                      color: Colors.pink,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          heightStat1 = 0.0;
                          resultStatistic1Heigth = 0.0;
                        },
                        );
                      },

                      child:
                      Icon(Icons.close_rounded, color: Colors.white,),
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
      height: heightStat1,
    );
    var showStat2 = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState( () {
                      print(val.fullname);
                      employeesList = val.fullname;},
                    );
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      onPressed: () {
                        print('SAVE');
                        checkStat2(employeesList);
                        resultStatistic2Heigth =  60.0;
                      },
                      child:
                      Text(
                          "Cмотреть", style: TextStyle(color: Colors.white)),
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          employeesList = 'Выберите сотрудника';
                        },
                        );
                      },

                      child:
                      Text(
                          "Сбросить", style: TextStyle(color: Colors.white)),
                      color: Colors.pink,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          heightStat2 = 0.0;
                          resultStatistic2Heigth = 0.0;
                        },
                        );
                      },

                      child:
                      Icon(Icons.close_rounded, color: Colors.white,),
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
      height: heightStat2,
    );
    var showStat3 = AnimatedContainer(
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
                  items: _getAllPharmacies.map(
                        (val) {
                      return DropdownMenuItem<Pharmacy>(
                        value: val,
                        child: Text(val.nameofpharm),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState( () {
                      print(val.nameofpharm);
                      pharmaciesList = val.nameofpharm;},
                    );
                  },
                ),
              ),
              SizedBox(height: 10,),
              Expanded(
                flex: 1,
                child: DropdownButton(
                  hint: datesList == null
                      ? Text('Выберите месяц')
                      : Text(
                    datesList,
                    style: TextStyle(color: Colors.blue),
                  ),
                  isExpanded: true,
                  iconSize: 30.0,
                  style: TextStyle(color: Colors.blue),
                  items: days.map(
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
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      onPressed: () {
                        print('SAVE');
                        checkStat3(pharmaciesList, datesList);
                        resultStatistic3Heigth = 60.0;
                      },
                      child:
                      Text(
                          "Cмотреть", style: TextStyle(color: Colors.white)),
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          pharmaciesList = 'Выберите аптеку';
                          datesList = 'Выберите месяц';
                        },
                        );
                      },

                      child:
                      Text(
                          "Сбросить", style: TextStyle(color: Colors.white)),
                      color: Colors.pink,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          heightStat3 = 0.0;
                          resultStatistic3Heigth = 0.0;
                        },
                        );
                      },

                      child:
                      Icon(Icons.close_rounded, color: Colors.white,),
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
      height: heightStat3,
    );
    var showStat4 = AnimatedContainer(
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
                  items: _getAllPharmacies.map(
                        (val) {
                      return DropdownMenuItem<Pharmacy>(
                        value: val,
                        child: Text(val.nameofpharm),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    setState( () {
                      print(val.nameofpharm);
                      pharmaciesList = val.nameofpharm;},
                    );
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      onPressed: () {
                        print('SAVE');
                        checkStat4(pharmaciesList);
                        resultStatistic4Heigth =  60.0;
                      },
                      child:
                      Text(
                          "Cмотреть", style: TextStyle(color: Colors.white)),
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          pharmaciesList = 'Выберите аптеку';
                        },
                        );
                      },

                      child:
                      Text(
                          "Сбросить", style: TextStyle(color: Colors.white)),
                      color: Colors.pink,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {
                        setState(() {
                          heightStat4 = 0.0;
                          resultStatistic4Heigth = 0.0;
                        },
                        );
                      },

                      child:
                      Icon(Icons.close_rounded, color: Colors.white,),
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
      height: heightStat4,
    );
    var showResultStatisticWidgetFirst = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(resStat1.toString()??'за выбранный месяц у сотрудника нет штрафов'),
                    ),
                  ]),
            ],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: resultStatistic1Heigth,
    );
    var showResultStatisticWidgetSecond = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(resStat2.toString()??'у сотрудника нет штрафов'),
                    ),
                  ]),
            ],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: resultStatistic2Heigth,
    );
    var showResultStatisticWidget3 = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(resStat3.toString()??'нет purchases'),
                    ),
                  ]),
            ],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: resultStatistic3Heigth,
    );
    var showResultStatisticWidget4 = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(resStat4.toString()??'нет purchases'),
                    ),
                  ]),
            ],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: resultStatistic4Heigth,
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,//color
          title: Text("PharmaC.", style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),),
          actions: <Widget>[
            FlatButton(
              minWidth: 12,
              onPressed: () {
//              sharedPreferences.clear();
//              sharedPreferences.commit();
//              sharedPreferences.setInt('news', 3);
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
              },
              child: Icon(Icons.home_outlined, color: Colors.white),
            ),
            FlatButton(
              minWidth: 12,
              onPressed: () {
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
              },
              child: Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            showResultStatisticWidgetFirst,
            showResultStatisticWidgetSecond,
            showResultStatisticWidget3,
            showResultStatisticWidget4,
            showStat1,
            showStat2,
            showStat3,
            showStat4,
            bodyStatistic,
//
          ],
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(
          ),child:
        Drawer(
          child: new ListView(

            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(userName??'username'),
                accountEmail: new Text(userEmail??'email'),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
              new Divider(),

            ],
          ),
        ),
        )
    );
  }
}
