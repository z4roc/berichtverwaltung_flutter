import 'package:berichtverwaltung_flutter/add/task_provider.dart';
import 'package:berichtverwaltung_flutter/main.dart';
import 'package:berichtverwaltung_flutter/models/bericht.dart';
import 'package:berichtverwaltung_flutter/services/firestore_service.dart';
import 'package:berichtverwaltung_flutter/tasks/tasks_page.dart';
import 'package:berichtverwaltung_flutter/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late final user;
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
  void initState() {
    super.initState();
    user = widget.user;
    nr.text = Calculations()
        .getBerichtNr(
          DateTime.fromMillisecondsSinceEpoch(
            user.ausbildungsbeginn.millisecondsSinceEpoch,
          ),
          DateTime.now(),
        )
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<TaskProvider>(context);
    final taskList = state.selectedTasks.map((e) => "- $e").join("\n");
    text1.text = taskList;
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: nr,
              decoration: decoBuilder('Bericht Nr.'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: pickDateRange,
              child: Column(
                children: [
                  const Text('Zeitraum'),
                  Text(
                    "📅 ${dtr.start.day}.${dtr.start.month}.${dtr.start.year} - ${dtr.end.day}.${dtr.end.month}.${dtr.end.year}",
                  ),
                ],
              ),
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
              controller: text1,
              decoration: decoBuilder('Betriebliche Aufgaben'),
              maxLines: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TaskPage(),
                    ),
                  );
                },
                child: const Text("Aufgaben hinzufügen"),
              ),
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
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: addBericht,
              child: const Text('Bericht erstellen'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addBericht() async {
    Bericht neu = Bericht(
      id: int.parse(nr.text),
      abteilung: abtl.text,
      datum_start: Timestamp.fromDate(dtr.start),
      datum_end: Timestamp.fromDate(dtr.end),
      aufgaben: text1.text,
      thema: text2.text,
      schule: text3.text,
    );
    try {
      FirestoreService().createBericht(neu);
      SnackBarProvider.showSnackBar(
          text: 'Bericht erfolgreich erstellt', type: SnackbarType.success);
      navigatorKey.currentState!.pop();
    } catch (e) {
      SnackBarProvider.showSnackBar(
        text: e.toString(),
        type: SnackbarType.error,
      );
    }
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
