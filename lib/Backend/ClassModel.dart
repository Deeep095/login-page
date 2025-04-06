import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  String classid;
  String className;
  String section;
  String subject;
  String teacherID;
  List<String> enrolledUser;

  ClassModel({
    required this.classid,
    required this.className,
    required this.section,
    required this.subject,
    required this.teacherID,
    required this.enrolledUser,
  });

  // Convert Firestore document into ClassModel
  factory ClassModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    // Map data = doc.data() as Map;
    final data = snapshot.data();
    return ClassModel(
      classid: snapshot.id,
      className: data?['className'] ?? '',
      section: data?['section'] ?? '',
      subject: data?['subject'] ?? '',
      teacherID: data?['teacherID'] ?? '',
      enrolledUser: data?['enrolledUser'] ?? '',
    );
  }

  factory ClassModel.fromMap(Map<String, dynamic> data, String docId) {
    return ClassModel(
      classid: docId, // Use Firestore document ID
      className: data['className'] ?? '',
      section: data['section'] ?? '',
      subject: data['subject'] ?? '',
      teacherID: data['teacherID'] ?? '',
      enrolledUser: List<String>.from(data['enrolledUser'] ?? []),
    );
  }

  // Convert ClassModel into Firestore-compatible format
  Map<String, dynamic> toFirestore() {
    return {
      'className': className,
      'section': section,
      'subject': subject,
      'teacherID': teacherID,
      'enrolledUsers': enrolledUser,
    };
  }
}
