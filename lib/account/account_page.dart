import 'package:berichtverwaltung_flutter/models/user.dart';
import 'package:berichtverwaltung_flutter/services/auth_service.dart';
import 'package:berichtverwaltung_flutter/services/firestore_service.dart';
import 'package:berichtverwaltung_flutter/widgets/flyout_nav.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().user;

    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
      ),
      body: StreamBuilder<AppUser?>(
          stream: FirestoreService().userStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final time =
                  snapshot.data?.ausbildungsbeginn.toDate() ?? DateTime.now();
              return SizedBox(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 6,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://marmotamaps.com/de/fx/wallpaper/download/faszinationen/Marmotamaps_Wallpaper_Berchtesgaden_Desktop_1920x1080.jpg"),
                        ),
                      ),
                    ),
                    ListTile(
                      title: const Text("E-Mail"),
                      subtitle: Text(user?.email ?? ""),
                    ),
                    ListTile(
                      title: const Text("Name"),
                      subtitle: Text(snapshot.data?.name ?? ""),
                    ),
                    ListTile(
                      title: const Text("Rolle"),
                      subtitle: Text(snapshot.data?.role ?? ""),
                    ),
                    ListTile(
                      title: const Text("Ausbildungsbeginn"),
                      subtitle: Text("${time.day}.${time.month}.${time.year}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await AuthService().signOut();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.logout_rounded),
                            Text('Sign out'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
