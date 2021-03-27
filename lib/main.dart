import 'package:farma_app/domain/user.dart';
import 'package:farma_app/pages/landing.dart';
import 'package:farma_app/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// void main() => runApp(FarmaApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FarmaApp());
}

class FarmaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser>.value(
      value: AuthService().currentUser,
      // initialData: null,
      child: MaterialApp(
          title: 'Farma',
          theme: ThemeData(
              primaryColor: Color.fromRGBO(50, 65, 85, 1),
              textTheme: TextTheme(headline6: TextStyle(color: Colors.white))),
          home: LandingPage()),
    );
  }
}
