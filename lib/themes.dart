import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blueGrey,
  appBarTheme: const AppBarTheme(
    centerTitle: true,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blueGrey,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(50),
    ),
  ),
);

ThemeData dark = ThemeData(
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
  ThemeMode themeMode =
      ThemeMode.system == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
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
