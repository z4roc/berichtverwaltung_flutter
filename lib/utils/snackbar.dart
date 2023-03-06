import 'package:flutter/material.dart';

enum SnackbarType { error, success, information }

class SnackBarProvider {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSnackBar({
    required String text,
    required SnackbarType type,
  }) {
    Color snackbarcolor;
    Icon snackbarIcon;

    switch (type) {
      case SnackbarType.error:
        snackbarcolor = const Color.fromARGB(255, 255, 115, 118);
        snackbarIcon = const Icon(
          Icons.close_rounded,
          color: Colors.white,
        );
        break;
      case SnackbarType.information:
        snackbarcolor = const Color.fromARGB(255, 85, 118, 209);
        snackbarIcon = const Icon(
          Icons.info_outline_rounded,
          color: Colors.white,
        );
        break;
      default:
        snackbarcolor = const Color.fromARGB(255, 119, 221, 119);
        snackbarIcon = const Icon(
          Icons.check_rounded,
          color: Colors.white,
        );
    }

    final snackbar = SnackBar(
      content: Row(
        children: [
          snackbarIcon,
          const SizedBox(
            width: 5,
          ),
          Text(text),
        ],
      ),
      elevation: 2,
      backgroundColor: snackbarcolor,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1, milliseconds: 500),
    );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }
}
