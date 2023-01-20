import 'package:berichtverwaltung_flutter/account/account_page.dart';
import 'package:berichtverwaltung_flutter/add/add_page.dart';
import 'package:berichtverwaltung_flutter/alle/alle_berichte.dart';
import 'package:berichtverwaltung_flutter/detail/detail_page.dart';
import 'package:berichtverwaltung_flutter/home/home_page.dart';
import 'package:berichtverwaltung_flutter/login/account_create.dart';
import 'package:berichtverwaltung_flutter/login/register_page.dart';

var appRoutes = {
  '/': (context) => const Home(),
  '/alle': (context) => const AllPage(),
  '/add': (context) => const AddPage(),
  '/account': (context) => const AccountPage(),
  '/register': (context) => const RegisterPage(),
  '/registerConfirm': (context) => const AccountCreatePage(),
};
