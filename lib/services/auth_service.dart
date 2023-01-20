import 'package:berichtverwaltung_flutter/main.dart';
import 'package:berichtverwaltung_flutter/utils/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final userStream = FirebaseAuth.instance.authStateChanges();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      SnackBarProvider.showSnackBar(text: e.message!, type: SnackbarType.error);
    }
  }

  Future<void> registerWithEmail(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      SnackBarProvider.showSnackBar(
        text: e.message!,
        type: SnackbarType.error,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      navigatorKey.currentState!.popUntil(ModalRoute.withName('/'));
    } on FirebaseAuthException catch (e) {
      SnackBarProvider.showSnackBar(
        text: e.message!,
        type: SnackbarType.error,
      );
    }
  }
}
