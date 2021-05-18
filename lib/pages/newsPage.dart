import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home.dart';
import 'loginPage.dart';

class NewsPage extends StatefulWidget {

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
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
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
              },
              child: Icon(Icons.arrow_back_outlined, color: Colors.white),
            ),
            FlatButton(
              minWidth: 12,
              onPressed: () {
                sharedPreferences.clear();
                sharedPreferences.commit();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
              },
//            child: Text("Log Out", style: TextStyle(color: Colors.white)),
              child: Icon(Icons.logout, color: Colors.white),
            ),
          ],
        ),
//      body: Center(child: Text("Main Page")),
        body: Text("will be",
            style: TextStyle(
                color: Theme.of(context).textTheme.headline6.color,
                fontWeight: FontWeight.bold)),
          //knopka nazad to HomEPAGE

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

            ],
          ),
        ),
        )
    );
  }
}
