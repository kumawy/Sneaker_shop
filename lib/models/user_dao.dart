import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserDao extends ChangeNotifier {
  String errorMsg = 'An error has occurred.';
  final auth = FirebaseAuth.instance;

  bool isLoggedIn() => auth.currentUser != null;

  String? userId() => auth.currentUser?.uid;

  String? email() => auth.currentUser?.email;

  Future<String?> signup(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (email.isEmpty) {
        errorMsg = 'Email is blank.';
      } else if (password.isEmpty) {
        errorMsg = 'Password is blank.';
      } else if (e.code == 'weak-password') {
        errorMsg = 'Password is too weak (min 6 chars).';
      } else if (e.code == 'email-already-in-use') {
        errorMsg = 'An account already exists for that email.';
      } else {
        errorMsg = e.message ?? 'Sign-up failed.';
      }
      return errorMsg;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (email.isEmpty) {
        errorMsg = 'Email is blank.';
      } else if (password.isEmpty) {
        errorMsg = 'Password is blank.';
      } else if (e.code == 'invalid-email') {
        errorMsg = 'Invalid email address.';
      } else if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'INVALID_LOGIN_CREDENTIALS') {
        errorMsg = 'Invalid credentials.';
      } else {
        errorMsg = e.message ?? 'Login failed.';
      }
      return errorMsg;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    notifyListeners();
  }
}
