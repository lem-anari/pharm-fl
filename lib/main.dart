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

import 'package:farma_app/pages/home.dart';
import 'package:farma_app/pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(FarmaApp());

class FarmaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pharma Control",
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
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

  @override
  void initState() {
    super.initState();
    checkLoginStatus();

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pharma Control", style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              sharedPreferences.clear();
              sharedPreferences.commit();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
            },
            child: Text("Log Out", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
//      body: Center(child: Text("Main Page")),
      body: HomePage(),
      drawer: Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(userName??'username'),
              accountEmail: new Text(userEmail??'email'),
            ),
            new Divider(),
          ],
        ),
      ),
    );
  }
}