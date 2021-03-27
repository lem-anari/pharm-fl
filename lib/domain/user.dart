import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';

class CustomUser {
  String id;
  // var id;

  CustomUser.fromFirebase(User customUser) {
    id = customUser.uid;
  }
  // CustomUser.fromPostgre(dynamic identificatorUser) {
  //   id = identificatorUser;
  // }
}
