import 'dart:io';

import 'package:berichtverwaltung_flutter/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import "package:http/http.dart" as http;

import '../models/bericht.dart';

class PdfService {
  Future<void> getVorlage() async {
    final storage = FirebaseStorage.instance.ref().child('/Vorlage.pdf');
    final dir = await getApplicationDocumentsDirectory();

    final file = File("${dir.path}/Vorlage.pdf");

    storage.writeToFile(file);
  }

  Future<void> getFont() async {
    final storage =
        FirebaseStorage.instance.ref().child('/FuturaCom-Medium.ttf');
    final dir = await getApplicationDocumentsDirectory();

    final file = File("${dir.path}/FuturaCom-Medium.ttf");

    storage.writeToFile(file);
  }

  Future<void> createPdf(Bericht bericht) async {
    //final dir = await getApplicationDocumentsDirectory();

    final user = await FirestoreService().getUser();

    var storagePdf = FirebaseStorage.instance.ref().child("/Vorlage.pdf");

    var downloadUrl = await storagePdf.getDownloadURL();
    var data = await storagePdf.getData();
    /*var data = await http.get(
      Uri.parse(downloadUrl),
    );*/

    var pdfBytes = data;

    PdfDocument pdf = PdfDocument(
      inputBytes:
          pdfBytes /*File("${dir.path}/Vorlage.pdf").readAsBytesSync()*/,
    );
    //File out = File("${dir.path}/${bericht.id}.pdf");

    final page = pdf.pages[0];

    var fontRef = FirebaseStorage.instance.ref().child("/FuturaCom-Medium.ttf");

    var fontBytes = (await fontRef.getData())!.toList();
    //(await http.get(Uri.parse(await fontRef.getDownloadURL()))).bodyBytes;

    final PdfFont font = PdfTrueTypeFont(
      fontBytes /*File("${dir.path}/FuturaCom-Medium.ttf").readAsBytesSync()*/,
      12,
    );

    page.graphics.drawString(
      bericht.id.toString(),
      font,
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(400, 46, 50, 50),
    );

    page.graphics.drawString(
      bericht.abteilung,
      font,
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(75, 74, 50, 50),
    );

    page.graphics.drawString(
      user.name,
      font,
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(455, 74, 150, 50),
    );

    page.graphics.drawString(
      "${bericht.datum_start.toDate().day}.${bericht.datum_start.toDate().month}.${bericht.datum_start.toDate().year}",
      font,
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(265, 75, 100, 50),
    );

    page.graphics.drawString(
      "${bericht.datum_end.toDate().day}.${bericht.datum_end.toDate().month}.${bericht.datum_end.toDate().year}",
      font,
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(350, 75, 100, 50),
    );

    page.graphics.drawString(
      bericht.aufgaben,
      font,
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(75, 125, 450, 500),
    );

    page.graphics.drawString(
      bericht.thema,
      font,
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(75, 360, 450, 500),
    );

    page.graphics.drawString(
      bericht.schule,
      font,
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(75, 595, 450, 500),
    );

    List<int> bytes = await pdf.save();
    //await out.writeAsBytes(bytes, flush: true);
    pdf.dispose();
    uploadPdf(bericht.id.toString(), bytes);
  }

  Future<void> uploadPdf(String filename, List<int> bytes) async {
    //final dir = await getApplicationDocumentsDirectory();
    //final filepath = "${dir.path}/$filename.pdf";

    //File file = File(filepath);

    final userRef = FirebaseStorage.instance
        .ref()
        .child("${FirebaseAuth.instance.currentUser!.uid}/$filename.pdf");

    try {
      //await userRef.putFile(file);
      await userRef.putData(Uint8List.fromList(bytes));

      await launchUrl(
        Uri.parse(await userRef.getDownloadURL()),
        mode: LaunchMode.externalApplication,
      );

      //await file.delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
