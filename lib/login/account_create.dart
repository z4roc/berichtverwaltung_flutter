import 'package:berichtverwaltung_flutter/main.dart';
import 'package:berichtverwaltung_flutter/models/user.dart';
import 'package:berichtverwaltung_flutter/services/auth_service.dart';
import 'package:berichtverwaltung_flutter/services/firestore_service.dart';
import 'package:berichtverwaltung_flutter/themes.dart';
import 'package:berichtverwaltung_flutter/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class AccountCreatePage extends StatefulWidget {
  const AccountCreatePage({super.key});

  @override
  State<AccountCreatePage> createState() => _AccountCreatePageState();
}

class _AccountCreatePageState extends State<AccountCreatePage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  DateTime? beginn;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account erstellen'),
        leading: IconButton(
          onPressed: () => AuthService().signOut(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Einrichtung abschließen',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 32,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Bevor wir beginnen können brauchen wir noch ein paar Daten',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            TextField(
              decoration: decoBuilder(
                'Vollständiger Name',
              ),
              controller: nameController,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: dateController,
              readOnly: true,
              onTap: () async {
                DateTime? dt = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (dt != null) {
                  String formatedDate = DateFormat("dd.MM.yyyy").format(dt);
                  setState(() {
                    dateController.text = formatedDate;
                    beginn = dt;
                  });
                }
              },
              decoration: decoBuilder(
                'Ausbildungsbeginn',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text != '' && beginn != null) {
                  try {
                    await FirestoreService().createUserData(
                      AppUser(
                        name: nameController.text,
                        ausbildungsbeginn: Timestamp.fromDate(beginn!),
                        role: 'azubi',
                      ),
                    );
                  } catch (e) {
                    SnackBarProvider.showSnackBar(
                      text: e.toString(),
                      type: SnackbarType.error,
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center();
                    },
                  );
                }
              },
              child: const Text('Einrichtung abschließen'),
            ),
          ],
        ),
      ),
    );
  }
}
