//import 'package:farma_app/domain/user.dart';
//import 'package:farma_app/pages/landing.dart';
//import 'package:farma_app/services/auth.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//
//// void main() => runApp(FarmaApp());
//void main() async {
//  WidgetsFlutterBinding.ensureInitialized();
//  await Firebase.initializeApp();
//  runApp(FarmaApp());
//}
//
//class FarmaApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return StreamProvider<CustomUser>.value(
//      value: AuthService().currentUser,
//      initialData: null,
//      child: MaterialApp(
//          title: 'Farma',
//          theme: ThemeData(
//              primaryColor: Color.fromRGBO(50, 65, 85, 1),
//              textTheme: TextTheme(headline6: TextStyle(color: Colors.white))),
//          home: LandingPage()),
//    );
//  }
//}

import 'dart:convert';

import 'package:farma_app/domain/salary.dart';
import 'package:farma_app/pages/home.dart';
import 'package:farma_app/pages/homeAdmin.dart';
import 'package:farma_app/pages/loginPage.dart';
import 'package:farma_app/pages/newsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(FarmaApp());

class FarmaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PharmaC.",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
//          backgroundColor: Colors.red,
          accentColor: Colors.white70
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  SharedPreferences sharedPreferences;
  String userName;
  String userEmail;
  String role;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    fetchUserFines().then((value) {
      setState((){
        _userFines.addAll(value);
      });
    });
    fetchUserSalary().then((value) {
      setState((){
        _userSalary.addAll(value);
      });
    });
    fetchUserSalaryStavka().then((value) {
      setState((){
        _userSalaryStavka.addAll(value);
      });
    });
    fetchUserFinesStory().then((value) {
      setState((){
        _userFinesStory.addAll(value);
      });
    });
  }

  List<SalaryFines> _userFines = List<SalaryFines>();
  Future <List<SalaryFines>> fetchUserFines() async{
    sharedPreferences = await SharedPreferences.getInstance();
    String UId =  sharedPreferences.getString("user_id");
    Map data = {
      'user_id': UId.toString()
    };
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/salaryEmployee/salaryFinesOfEmployee"), body: data);
    var fines = List<SalaryFines>();

    if(response.statusCode == 200) {

      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> finesJson = map["fines_month"];
      print('ffffffffffff: ${finesJson}');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      for(var fineJson in finesJson){
        fines.add(SalaryFines.fromJson(fineJson));
      }
    }
    print('dddddddd: ${fines.length}');
    return fines;
  }

  List<SalaryUser> _userSalary = List<SalaryUser>();
  Future <List<SalaryUser>> fetchUserSalary() async{
    sharedPreferences = await SharedPreferences.getInstance();
    String UId =  sharedPreferences.getString("user_id");
    Map data = {
      'user_id': UId.toString()
    };
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/salaryEmployee/salaryFinesOfEmployee"), body: data);
    var salaries = List<SalaryUser>();

    if(response.statusCode == 200) {

      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> salaryJson = map["salary"];
      print('ffffffffffff: ${salaryJson}');

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      for(var fineJson in salaryJson){
        salaries.add(SalaryUser.fromJson(fineJson));
      }
    }
    print('dddddddd: ${salaries.length}');
    return salaries;
  }
  List<SalaryUserStavka> _userSalaryStavka = List<SalaryUserStavka>();
  Future <List<SalaryUserStavka>> fetchUserSalaryStavka() async{
    sharedPreferences = await SharedPreferences.getInstance();
    String UId =  sharedPreferences.getString("user_id");
    Map data = {
      'user_id': UId.toString()
    };
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/salaryEmployee/salaryFinesOfEmployee"), body: data);
    var salariesSt = List<SalaryUserStavka>();
    if(response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> salaryJson = map["salaryStavka"];
      for(var stavkaJson in salaryJson){
        salariesSt.add(SalaryUserStavka.fromJson(stavkaJson));
      }
    }
    return salariesSt;
  }

  List<FinesStory> _userFinesStory = List<FinesStory>();
  Future <List<FinesStory>> fetchUserFinesStory() async{
    sharedPreferences = await SharedPreferences.getInstance();
    String UId =  sharedPreferences.getString("employee_id");
    Map data = {
      'user_id': UId.toString()
    };
    print('EMPLOYEE ID ${UId}');
    var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/salaryEmployee/salaryFinesOfEmployee"), body: data);
    var fines = List<FinesStory>();
    if(response.statusCode == 200) {
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> salaryJson = map["array_fines"];
      for(var stavkaJson in salaryJson){
        fines.add(FinesStory.fromJson(stavkaJson));
      }
    }
    print('FINES');
//    print(fines);
    return fines;
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
      role = await sharedPreferences.getString("role");
      setState(() {});

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.red,
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
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => NewsPage()), (Route<dynamic> route) => false);
            },
            child: Icon(Icons.new_releases_outlined, color: Colors.white),
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
      // ignore: unrelated_type_equality_checks
      body: (role == 1) ? HomePageAdmin() : HomePage(),

    drawer: Theme(
    data: Theme.of(context).copyWith(
//    canvasColor: Colors.black, //
//      cardColor: Colors.black,
//      colorScheme: Colors.black
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
      Padding(
        padding: EdgeInsets.symmetric(vertical: 10,  horizontal: 15),
        child:
      Align(
        alignment: Alignment.topCenter,
        child: Expanded(
            child: SizedBox(
                height: 100.0,
            child: ListView.builder(

            itemCount: _userFines.length,
            itemBuilder: (context, i) {
              return
                Column(
                  children: [
                    Text('текущий месяц'),
                Row(
                  children: [
                    Text('штрафы: '),
                    (_userFines[i].fines != 'null') ?
                    Text(_userFines[i].fines) :
                    Text('0')
                  ],
                ),
                Row(
                  children: [
                    Text('бонусы: '),
                    (_userFines[i].fines != 'null') ?
                    Text(_userFines[i].fines) :
                    Text('will be')
                  ],
                ),
                Row(
                  children: [
                    Text('ставка: '),
                    (_userSalaryStavka[i].salary != 'null') ?
                    Text(_userSalaryStavka[i].salary) :
                    Text('0')
                  ],
                ),
                    Row(
                      children: [
                        Text('итог: '),
                        (_userSalary[i].salary != 'null') ?
                        Text(_userSalary[i].salary) :
                        Text('0')
                      ],
                    ),
                  ],
                );
            })
      )),

      )),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10,  horizontal: 15),
                child:
                Align(
                  alignment: Alignment.topCenter,
                  child: Expanded(
                      child: SizedBox(
                          height: 200.0,
                          child: ListView.builder(
                              itemCount: _userFinesStory.length,
                              itemBuilder: (context, i) {
                                return
                                  Column(
                                    children: [
                                      Text('месяц: 0${i+1}'),
                                      Row(
                                        children: [
                                          Text('штрафы: '),
                                          (_userFinesStory[i].fine != 'null') ?
                                          Text(_userFinesStory[i].fine) :
                                          Text('0')
                                        ],
                                      ),
//                                      Row(
//                                        children: [
//                                          Text('бонусы: '),
//                                          (_userFines[i].fines != 'null') ?
//                                          Text(_userFines[i].fines) :
//                                          Text('will be')
//                                        ],
//                                      ),
                                    ],
                                  );
                              })
                      )),
                ))
          ],
        ),
      ),
    )
    );
  }
}