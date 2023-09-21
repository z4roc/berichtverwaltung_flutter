import 'package:berichtverwaltung_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

ThemeData light = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  //primarySwatch: Colors.lightBlue,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      //backgroundColor: Colors.lightBlue,
      ),
  elevatedButtonTheme: ElevatedButtonThemeData(),
);

ThemeData dark = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(50),
    ),
  ),
);

InputDecoration decoBuilder(String text) {
  return InputDecoration(
    border: const OutlineInputBorder(),
    labelText: text,
  );
}

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    loadInitialTheme();
  }

  void loadInitialTheme() {
    bool isDark = prefs.getBool("dark") ?? false;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  ThemeMode themeMode =
      ThemeMode.system == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    prefs.setBool("dark", isDark);
    notifyListeners();
  }
}

class ChangeThemeButton extends StatelessWidget {
  const ChangeThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return IconButton(
      icon: Icon(
        themeProvider.isDarkMode ? Icons.nights_stay_rounded : Icons.wb_sunny,
      ),
      onPressed: () {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme(!themeProvider.isDarkMode);
      },
    );
  }
}
