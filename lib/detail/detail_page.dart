import 'package:berichtverwaltung_flutter/main.dart';
import 'package:berichtverwaltung_flutter/services/firestore_service.dart';
import 'package:berichtverwaltung_flutter/services/pdf_service.dart';
import 'package:berichtverwaltung_flutter/utils/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/bericht.dart';
import '../themes.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.bericht});

  final Bericht bericht;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late DateTimeRange dtr;

  TextEditingController abtl = TextEditingController();
  TextEditingController aufgaben = TextEditingController();
  TextEditingController thema = TextEditingController();
  TextEditingController schule = TextEditingController();

  @override
  void initState() {
    super.initState();
    dtr = DateTimeRange(
      start: widget.bericht.datum_start.toDate(),
      end: widget.bericht.datum_end.toDate(),
    );

    abtl.text = widget.bericht.abteilung;
    aufgaben.text = widget.bericht.aufgaben;
    thema.text = widget.bericht.thema;
    schule.text = widget.bericht.schule;
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final bericht = widget.bericht;
    return Scaffold(
      appBar: AppBar(
        title: Text('Bericht Nr. ${bericht.id}'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete_rounded,
              color: Colors.red.shade400,
            ),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            navigatorKey.currentState!.pop();
          },
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: abtl,
                decoration: decoBuilder('Abteilung'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
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
                },
                child: Text(
                  '📅 ${dtr.start.day}.${dtr.start.month}.${dtr.start.year} - ${dtr.end.day}.${dtr.end.month}.${dtr.end.year}',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: aufgaben,
                decoration: decoBuilder('Betriebliche Aufgaben'),
                maxLines: 5,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: thema,
                decoration: decoBuilder('Betriebliches Thema'),
                maxLines: 5,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: schule,
                decoration: decoBuilder('Schulthemen'),
                maxLines: 5,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  await FirestoreService().createBericht(
                    Bericht(
                      id: bericht.id,
                      abteilung: abtl.text,
                      datum_start: Timestamp.fromDate(dtr.start),
                      datum_end: Timestamp.fromDate(dtr.end),
                      aufgaben: aufgaben.text,
                      thema: thema.text,
                      schule: schule.text,
                    ),
                  );
                  SnackBarProvider.showSnackBar(
                    text: "Bericht erfolgreich bearbeitet",
                    type: SnackbarType.success,
                  );
                },
                child: const Text('Änderungen speichern 💾'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      barrierDismissible: false,
                    );
                    isLoading = true;
                    //final dir = await getApplicationDocumentsDirectory();
                    /*if (!await File("${dir.path}/Vorlage.pdf").exists()) {
                      await PdfService().getVorlage();
                    }*/

                    /*if (!await File("${dir.path}/FuturaCom-Medium.ttf")
                        .exists()) {
                      await PdfService().getFont();
                    }*/

                    await PdfService().createPdf(
                      Bericht(
                        id: bericht.id,
                        abteilung: abtl.text,
                        datum_start: Timestamp.fromDate(dtr.start),
                        datum_end: Timestamp.fromDate(dtr.end),
                        aufgaben: aufgaben.text,
                        thema: thema.text,
                        schule: schule.text,
                      ),
                    );
                    isLoading = false;
                    navigatorKey.currentState!.pop();
                  } catch (e) {
                    SnackBarProvider.showSnackBar(
                      text: e.toString(),
                      type: SnackbarType.error,
                    );
                    isLoading = false;
                    navigatorKey.currentState!.pop();
                  }
                },
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('PDF herunterladen 📁'),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
