import 'package:flutter/material.dart';

enum SnackbarType { error, success, information }

class SnackBarProvider {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar({
    required String text,
    required SnackbarType type,
  }) {
    Color snackbarcolor;

    switch (type) {
      case SnackbarType.error:
        snackbarcolor = const Color.fromARGB(255, 255, 115, 118);
        break;
      case SnackbarType.information:
        snackbarcolor = const Color.fromARGB(255, 85, 118, 209);
        break;
      default:
        snackbarcolor = const Color.fromARGB(255, 119, 221, 119);
    }

    final snackbar = SnackBar(
      content: Text(text),
      backgroundColor: snackbarcolor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1, milliseconds: 500),
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }
}
