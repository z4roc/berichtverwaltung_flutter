import 'package:berichtverwaltung_flutter/services/firestore_service.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/calculation_service.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neuer Bericht'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CreateField(user: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        stream: FirestoreService().userStream(),
      ),
    );
  }
}

class CreateField extends StatefulWidget {
  final AppUser user;

  const CreateField({super.key, required this.user});

  @override
  State<CreateField> createState() => _CreateFieldState();
}

class _CreateFieldState extends State<CreateField> {
  TextEditingController nr = TextEditingController();
  TextEditingController abtl = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController text1 = TextEditingController();
  TextEditingController text2 = TextEditingController();
  TextEditingController text3 = TextEditingController();

  InputDecoration decoBuilder(String text) {
    return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: text,
    );
  }

  DateTimeRange dtr = DateTimeRange(
    start: DateTime.now().subtract(
      const Duration(days: 7),
    ),
    end: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    nr.text = Calculations()
        .getBerichtNr(
          DateTime.fromMillisecondsSinceEpoch(
            user.ausbildungsbeginn.millisecondsSinceEpoch,
          ),
          DateTime.now(),
        )
        .toString();

    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: nr,
              decoration: decoBuilder('Bericht Nr.'),
            ),
            const SizedBox(),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Text('Datum (von, bis): '),
                ElevatedButton(
                  onPressed: pickDateRange,
                  child: Text(
                      "${dtr.start.day}.${dtr.start.month}.${dtr.start.year} - ${dtr.end.day}.${dtr.end.month}.${dtr.end.year}"),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: abtl,
              decoration: decoBuilder('Abteilung'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: name,
              decoration: decoBuilder('Name'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: text1,
              decoration: decoBuilder('Betriebliche Aufgaben'),
              maxLines: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: text2,
              decoration: decoBuilder('Betriebliches Thema'),
              maxLines: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: text3,
              decoration: decoBuilder('Schule'),
              maxLines: 5,
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('Bericht speichern'),
            )
          ],
        ),
      ),
    );
  }

  Future pickDateRange() async {
    DateTimeRange? newDtr = await showDateRangePicker(
      context: context,
      initialDateRange: dtr,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (newDtr == null) return;
    setState(() {
      dtr = newDtr;
    });
  }
}
