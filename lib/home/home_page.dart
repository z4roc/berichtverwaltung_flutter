import 'package:berichtverwaltung_flutter/models/user.dart';
import 'package:berichtverwaltung_flutter/services/auth_service.dart';
import 'package:berichtverwaltung_flutter/services/firestore_service.dart';
import 'package:berichtverwaltung_flutter/widgets/dashboard_overview.dart';
import 'package:flutter/material.dart';

import '../login/login_page.dart';
import '../widgets/flyout_nav.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Text('Überprüfe deine Internetverbindung');
          } else if (snapshot.hasData) {
            return const DashboardPage();
          } else {
            return const LoginPage();
          }
        });
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('Ausbildungsberichte'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            FutureBuilder<AppUser>(
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  return Overview(data: snapshot.data!);
                } else {
                  return const Text('Keine Daten gefunden');
                }
              },
              future: FirestoreService().getUserData(),
            ),
          ],
        ),
      ),
    );
  }
}
