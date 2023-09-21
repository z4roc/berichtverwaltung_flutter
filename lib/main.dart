import 'package:berichtverwaltung_flutter/add/task_provider.dart';
import 'package:berichtverwaltung_flutter/env/env.dart';
import 'package:berichtverwaltung_flutter/firebase_options.dart';
import 'package:berichtverwaltung_flutter/routes.dart';
import 'package:berichtverwaltung_flutter/themes.dart';
import 'package:berichtverwaltung_flutter/utils/snackbar.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OpenAI.apiKey = Env.openAIKey;
  prefs = await SharedPreferences.getInstance();
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
              return ChangeNotifierProvider(
                create: (_) => TaskProvider(),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: light,
                  darkTheme: dark,
                  themeMode: themeProvider.themeMode,
                  routes: appRoutes,
                  scaffoldMessengerKey: SnackBarProvider.messengerKey,
                  navigatorKey: navigatorKey,
                ),
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
