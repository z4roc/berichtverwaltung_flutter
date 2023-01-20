import 'package:berichtverwaltung_flutter/models/bericht.dart';
import 'package:berichtverwaltung_flutter/models/user.dart';
import 'package:berichtverwaltung_flutter/utils/snackbar.dart';
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

  Future<AppUser?> getUserData() async {
    if (user == null) {
      return AppUser(
          name: '', ausbildungsbeginn: Timestamp.now(), role: 'azubi');
    }

    var userdata = await _db.collection('users').doc(user!.uid).get();
    if (!userdata.exists) {
      return null;
    }
    return AppUser.fromJson(userdata.data()!);
  }

  Future<void> createUserData(AppUser appUser) async {
    final userData = await _db.collection('users').doc(user!.uid).set(
          appUser.toJson(),
        );
  }

  Stream<List<Bericht>> berichtStream() => _db
      .collection('users')
      .doc(user!.uid)
      .collection('berichte')
      .orderBy('id', descending: true)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((e) => Bericht.fromJson(e.data())).toList());

  Stream<AppUser>? userStream() => _db
      .collection('users')
      .doc(user!.uid)
      .snapshots()
      .map((appuser) => AppUser.fromJson(appuser.data()!));

  Future<AppUser> getUser() async {
    final doc = await _db.collection('users').doc(user!.uid).get();
    return AppUser.fromJson(doc.data()!);
  }

  Future<void> createBericht(Bericht neu) async {
    try {
      final colref =
          _db.collection('users').doc(user!.uid).collection('berichte');
      colref.doc(neu.id.toString()).set(neu.toJson());
    } catch (e) {
      SnackBarProvider.showSnackBar(
        text: "Fehler beim erstellen des Berichts",
        type: SnackbarType.error,
      );
    }
  }

  Future<void> deleteBericht(int id) async {
    try {
      _db
          .collection('users')
          .doc(user!.uid)
          .collection('berichte')
          .doc(id.toString())
          .delete();
      SnackBarProvider.showSnackBar(
        text: 'Bericht Nr.$id gelöscht',
        type: SnackbarType.information,
      );
    } catch (e) {
      SnackBarProvider.showSnackBar(
        text: 'Fehler beim löschen des Berichts',
        type: SnackbarType.error,
      );
    }
  }
}
