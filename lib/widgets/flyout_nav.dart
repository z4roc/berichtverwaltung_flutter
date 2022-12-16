import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final currentUser = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const Avatar(),
            accountName: const Text(''),
            accountEmail: Text(currentUser!.email!),
            decoration: const BoxDecoration(
              color: Colors.green,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    "https://marmotamaps.com/de/fx/wallpaper/download/faszinationen/Marmotamaps_Wallpaper_Berchtesgaden_Desktop_1920x1080.jpg"),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text('Startseite'),
              onTap: () => Navigator.popUntil(
                context,
                ModalRoute.withName('/'),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Account'),
              onTap: () => Navigator.pushNamed(context, '/account'),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Alle Berichte'),
              onTap: () => Navigator.pushNamed(context, '/alle'),
            ),
          ),
          const Spacer(),
          const Divider(),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ListTile(
              leading: Icon(
                themeProvider.isDarkMode
                    ? Icons.nights_stay_rounded
                    : Icons.wb_sunny,
              ),
              title: const Text('Toggle Theme'),
              onTap: () {
                final provider =
                    Provider.of<ThemeProvider>(context, listen: false);
                provider.toggleTheme(!themeProvider.isDarkMode);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Avatar extends StatefulWidget {
  const Avatar({super.key});

  @override
  State<Avatar> createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    final userImg = FirebaseAuth.instance.currentUser!.photoURL;
    final firstLetter =
        FirebaseAuth.instance.currentUser!.email!.substring(0, 1).toUpperCase();

    return userImg != null
        ? CircleAvatar(
            child: ClipOval(
              child: Image.network(
                userImg,
                height: 90,
                width: 90,
              ),
            ),
          )
        : CircleAvatar(
            child: ClipOval(
              child: Container(
                color: Colors.green,
                height: 90,
                width: 90,
                child: Center(
                  child: Text(
                    firstLetter,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
