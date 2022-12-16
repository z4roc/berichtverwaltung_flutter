import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String name;
  final Timestamp ausbildungsbeginn;
  final String role;

  AppUser({
    required this.name,
    required this.ausbildungsbeginn,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'ausbildungsbeginn': ausbildungsbeginn,
        'role': role,
      };

  static AppUser fromJson(Map<String, dynamic> json) => AppUser(
        name: json['name'],
        ausbildungsbeginn: json['ausbildungsbeginn'],
        role: json['role'],
      );
}
