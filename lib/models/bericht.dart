import 'package:cloud_firestore/cloud_firestore.dart';

class Bericht {
  final int id;
  final String abteilung;
  final Timestamp datum_start;
  final Timestamp datum_end;
  final String aufgaben;
  final String thema;
  final String schule;

  Bericht({
    required this.id,
    required this.abteilung,
    required this.datum_start,
    required this.datum_end,
    required this.aufgaben,
    required this.thema,
    required this.schule,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'abteilung': abteilung,
        'datum_start': datum_start,
        'datum_end': datum_end,
        'aufgaben': aufgaben,
        'thema': thema,
        'schule': schule,
      };

  static Bericht fromJson(Map<String, dynamic> json) => Bericht(
        id: json['id'],
        abteilung: json['abteilung'],
        datum_start: json['datum_start'],
        datum_end: json['datum_end'],
        aufgaben: json['aufgaben'],
        thema: json['thema'],
        schule: json['schule'],
      );
}
