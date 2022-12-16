import 'package:berichtverwaltung_flutter/account/account_page.dart';
import 'package:berichtverwaltung_flutter/add/add_page.dart';
import 'package:berichtverwaltung_flutter/alle/alle_berichte.dart';
import 'package:berichtverwaltung_flutter/home/home_page.dart';

var appRoutes = {
  '/': (context) => const Home(),
  '/alle': (context) => const AllPage(),
  '/add': (context) => const AddPage(),
  '/account': (context) => const AccountPage(),
};
