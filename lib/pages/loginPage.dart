import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _isLoading = false;
  bool showlogin = true;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
//              colors: [Colors.pink[300], Colors.pink[100]],
              colors: [Color.fromRGBO(199,159,239, 1), Colors.pink[100]],

//              colors: [Colors.pink[200], Color.fromRGBO(230, 230, 250, 0.9)],

              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            headerSection(),
            textSection(),
            (showlogin
                ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                    child: Text('Забыли пароль?',
                        style: TextStyle(
                            fontSize: 15, color: Colors.white)),
                    onTap: () {
//                  setState(() {
//                    showlogin = false;
//                  });
                    }),
                SizedBox(width: 35, height: 50)
              ],
            )


                : SizedBox()),
            buttonSection(),
//            SizedBox(height: 100),
            (showlogin
              ? Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                    child: Text('Not registered yet? Register!',
                    style: TextStyle(
                    fontSize: 20, color: Colors.white)),
                    onTap: () {
                    setState(() {
                    showlogin = false;
                    });
                    }),
                  )
                  ],
                  )
                      : Column(
                  children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: GestureDetector(
                    child: Text('Already registered? Login!',
                    style: TextStyle(
                    fontSize: 20, color: Colors.white)),
                    onTap: () {
                    setState(() {
                    showlogin = true;
                    });
                }),

            ),
                  ],

            )),
            _bottomWave(),

          ],
        ),
      ),
    );
  }

  resetPassword(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email
    };
    var jsonResponse = null;

    var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/password/create"), body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
//      if(jsonResponse != null) {
//        sharedPreferences.setString("token", jsonResponse['token']);
//        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
//      }
    }
    else {
//      setState(() {
////        _isLoading = false;
//      });
    }
  }
  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'password': pass
    };
    var jsonResponse = null;

    var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/login"), body: data);
//    var response = await http.post(Uri.parse("http://192.168.0.105:8000/api/login"), body: data);

    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
        sharedPreferences.setString("name", jsonResponse['name']);
        sharedPreferences.setString("email", jsonResponse['email']);
        sharedPreferences.setString("user_id", jsonResponse['user_id'].toString());
        sharedPreferences.setString("employee_id", jsonResponse['employee_id'].toString());
        sharedPreferences.setString("role", jsonResponse['role'].toString());
//        print('WIHEFOIWHEFHEWLFHL');
//        print(sharedPreferences.getString("user_id"));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Ошибка авторизации. Проверьте email или пароль",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(response.body);
//      sharedPreferences.clear();
    }
  }

  signUp(String name, email, pass, passConfirm) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'name': name,
      'email': email,
      'password': pass,
      'password_confirmation': passConfirm,
    };
    var jsonResponse = null;

    var response = await http.post(Uri.parse("http://10.0.2.2:8000/api/register"), body: data);
    if(response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(jsonResponse != null) {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", jsonResponse['token']);
//        sharedPreferences.setString("user_id", jsonResponse['user_id']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MainPage()), (Route<dynamic> route) => false);
      }
    }
    else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "Регистрация невозможна. Проверьте email или пароль",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print(response.body);
    }
  }

  Container buttonSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 5.0),
      child: RaisedButton(
        onPressed: emailController.text == "" || passwordController.text == "" ? null : () {
          setState(() {
            _isLoading = true;
          });
          showlogin
              ? signIn(emailController.text, passwordController.text)
              : signUp(nameController.text, emailController.text, passwordController.text, passwordConfirmController.text);

        },
        elevation: 0.0,
        color: Colors.pink[400],
        child: (showlogin
            ? Text("Sign In", style: TextStyle(color: Colors.white70))
            : Text("Sign Up", style: TextStyle(color: Colors.white70))),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );
  }

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordConfirmController = new TextEditingController();

  Widget _bottomWave() {
    return Expanded(
      child: Align(
        child: ClipPath(
          child: Container(
            color: Colors.white,
            height: 300,
          ),
          clipper: BottomWaveClipper(),
        ),
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  Container textSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 0),
      child: Column(
        children: <Widget>[
          (showlogin
              ? SizedBox(height: 0)
              : TextFormField(
                controller: nameController,
                cursorColor: Colors.white,

            style: TextStyle(color: Colors.black, fontSize: 20),
//            style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  icon: Icon(Icons.supervised_user_circle, color: Colors.white70),
                  hintText: "Name",
                  border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                  hintStyle: TextStyle(color: Colors.white70),
                ),
              )),
              SizedBox(height: 30.0),
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,

//            style: TextStyle(color: Colors.white70),
            style: TextStyle(color: Colors.black, fontSize: 20),
            decoration: InputDecoration(
              icon: Icon(Icons.email, color: Colors.white70),
              hintText: "Email",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),
          SizedBox(height: 30.0),
          TextFormField(
            controller: passwordController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.black, fontSize: 20),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          ),SizedBox(height: 30.0),
          (showlogin
              ? SizedBox(height: 0)
              : TextFormField(
            controller: passwordConfirmController,
            cursorColor: Colors.white,
            obscureText: true,
            style: TextStyle(color: Colors.black, fontSize: 20),
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.white70),
              hintText: "Confirm password",
              border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
              hintStyle: TextStyle(color: Colors.white70),
            ),
          )),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 25.0),
      child: Text("Pharmacy Control",
          style: TextStyle(
              color: Colors.white70,
              fontSize: 30.0,
              fontWeight: FontWeight.normal)),
    );
  }
}
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height + 5);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}