import 'package:berichtverwaltung_flutter/firebase_options.dart';
import 'package:berichtverwaltung_flutter/routes.dart';
import 'package:berichtverwaltung_flutter/themes.dart';
import 'package:berichtverwaltung_flutter/utils/snackbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  final Future<FirebaseApp> _init =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _init,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Server issues, try later'),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
            builder: (context, child) {
              final themeProvider = Provider.of<ThemeProvider>(context);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: light,
                darkTheme: dark,
                themeMode: themeProvider.themeMode,
                routes: appRoutes,
                scaffoldMessengerKey: SnackBarProvider.messengerKey,
                navigatorKey: navigatorKey,
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
