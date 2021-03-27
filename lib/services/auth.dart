import 'dart:async';

import 'package:farma_app/domain/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _fAuth = FirebaseAuth.instance;

  Future<CustomUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return CustomUser.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future<CustomUser> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _fAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return CustomUser.fromFirebase(user);
    } catch (e) {
      return null;
    }
  }

  Future logOut() async {
    await _fAuth.signOut();
  }

  Stream<CustomUser> get currentUser {
    return _fAuth.authStateChanges().map(
        (User user) => user != null ? CustomUser.fromFirebase(user) : null);
  }
}
