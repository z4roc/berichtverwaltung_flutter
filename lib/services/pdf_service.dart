import 'dart:io';
import 'dart:ui';

import 'package:berichtverwaltung_flutter/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/bericht.dart';

class PdfService {
  Future<void> getVorlage() async {
    final storage = FirebaseStorage.instance.ref().child('/Vorlage.pdf');
    final dir = await getApplicationDocumentsDirectory();

    final file = File("${dir.path}/Vorlage.pdf");

    storage.writeToFile(file);
  }

  Future<void> createPdf(Bericht bericht) async {
    final dir = await getApplicationDocumentsDirectory();
    final user = await FirestoreService().getUser();
    PdfDocument pdf = PdfDocument(
      inputBytes: File("${dir.path}/Vorlage.pdf").readAsBytesSync(),
    );
    File out = File("${dir.path}/${bericht.id}.pdf");

    final page = pdf.pages[0];

    page.graphics.drawString(
      bericht.id.toString(),
      PdfStandardFont(
        PdfFontFamily.helvetica,
        12,
      ),
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(400, 46, 50, 50),
    );

    page.graphics.drawString(
      bericht.abteilung,
      PdfStandardFont(
        PdfFontFamily.helvetica,
        12,
      ),
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(75, 75, 50, 50),
    );

    page.graphics.drawString(
      user.name,
      PdfStandardFont(
        PdfFontFamily.helvetica,
        12,
      ),
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(455, 75, 150, 50),
    );

    page.graphics.drawString(
      "${bericht.datum_start.toDate().day}.${bericht.datum_start.toDate().month}.${bericht.datum_start.toDate().year}",
      PdfStandardFont(
        PdfFontFamily.helvetica,
        12,
      ),
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(265, 75, 100, 50),
    );

    page.graphics.drawString(
      "${bericht.datum_end.toDate().day}.${bericht.datum_end.toDate().month}.${bericht.datum_end.toDate().year}",
      PdfStandardFont(
        PdfFontFamily.helvetica,
        12,
      ),
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(350, 75, 100, 50),
    );

    page.graphics.drawString(
      bericht.aufgaben,
      PdfStandardFont(
        PdfFontFamily.helvetica,
        12,
      ),
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(75, 125, 500, 500),
    );

    page.graphics.drawString(
      bericht.thema,
      PdfStandardFont(
        PdfFontFamily.helvetica,
        12,
      ),
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(75, 360, 500, 500),
    );

    page.graphics.drawString(
      bericht.schule,
      PdfStandardFont(
        PdfFontFamily.helvetica,
        12,
      ),
      brush: PdfSolidBrush(
        PdfColor(0, 0, 0),
      ),
      bounds: const Rect.fromLTWH(75, 585, 500, 500),
    );

    List<int> bytes = await pdf.save();
    await out.writeAsBytes(bytes, flush: true);
    pdf.dispose();

    uploadPdf(bericht.id.toString());
  }

  Future<void> uploadPdf(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final filepath = "${dir.path}/$filename.pdf";

    File file = File(filepath);

    final userRef = FirebaseStorage.instance
        .ref()
        .child("${FirebaseAuth.instance.currentUser!.uid}/$filename.pdf");

    try {
      await userRef.putFile(file);

      await launchUrl(
        Uri.parse(await userRef.getDownloadURL()),
        mode: LaunchMode.externalApplication,
      );

      await file.delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
