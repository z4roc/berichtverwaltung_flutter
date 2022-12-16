import 'package:berichtverwaltung_flutter/models/bericht.dart';
import 'package:berichtverwaltung_flutter/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<List<Map<String, dynamic>>> getBerichte() async {
    var colRef = _db.collection('users').doc(user!.uid).collection('berichte');

    var snapshot = await colRef.get();
    var data = snapshot.docs.map((e) => e.data());
    return data.toList();
  }

  Future<AppUser> getUserData() async {
    if (user == null) {
      return AppUser(
          name: '', ausbildungsbeginn: Timestamp.now(), role: 'azubi');
    }

    var userdata = await _db.collection('users').doc(user!.uid).get();

    return AppUser.fromJson(userdata.data()!);
  }

  Future<List<Bericht>> getAlleBerichte() async {
    var coldata = await _db
        .collection('users')
        .doc(user!.uid)
        .collection('berichte')
        .get();

    return coldata.docs.map((e) => Bericht.fromJson(e.data())).toList();
  }

  Stream<AppUser> userStream() => _db
      .collection('users')
      .doc(user!.uid)
      .snapshots()
      .map((appuser) => AppUser.fromJson(appuser.data()!));
}
