// ignore_for_file: subtype_of_sealed_class, avoid_print, unused_local_variable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum loggedInState { isLoading, loggedIn, loggedOut }

class AuthState extends ChangeNotifier {
  late loggedInState _isLoggedIn;
  late String _error;

  loggedInState get isUserLoggedIn => _isLoggedIn;
  String get error => _error;

  signUp(String name, String email, String password, String pwConfrim) async {
    if (password != pwConfrim) {
      return {'message': 'Passwords are not the same!', 'isError': true};
    }

    try {
      return await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      final err = e as FirebaseAuthException;
      return {'message': err.message, 'isError': true};
    }
  }

  login(String email, String password) async {
    try {
      return await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("error");
      final err = e as FirebaseAuthException;

      return {'message': err.message, 'isError': true};
    }
  }

  anonLogin() async {
    try {
      return await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      print("error");
      final err = e as FirebaseAuthException;

      return {'message': err.message, 'isError': true};
    }
  }

  logout() async {
    FirebaseAuth.instance.signOut();
    _isLoggedIn = loggedInState.isLoading;
    notifyListeners();
    return "Signed Out";
  }
}
