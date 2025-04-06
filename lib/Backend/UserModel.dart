import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String name;
  String email;
  String role; // HOD, teacher, professor, student
  String? department; // Only for professors and HODs
  List<String> classIDs; // The classes this user is associated with

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.department,
    required this.classIDs,
  });

  // Convert Firestore document into UserModel
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      department: data['department'],
      classIDs: List<String>.from(data['classIDs'] ?? []),
    );
  }

  // Convert UserModel into Firestore-compatible format
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'department': department,
      'classIDs': classIDs,
    };
  }
}
