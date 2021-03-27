// import 'package:firebase_core/firebase_core.dart';
import 'package:farma_app/domain/user.dart';
import 'package:flutter/material.dart';
import 'package:farma_app/pages/auth.dart';
import 'package:farma_app/pages/home.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomUser customUser = Provider.of<CustomUser>(context);
    final bool isLoggedIn = customUser != null;

    return isLoggedIn ? HomePage() : AuthorizationPage();
  }
}
