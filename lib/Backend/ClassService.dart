// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'ClassModel.dart';
//
// class ClassService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   // Create or update a class in Firestore
//   Future<void> saveClass(ClassModel classModel) async {
//     await _firestore.collection('classes').doc(classModel.classid).set(classModel.toFirestore());
//   }
//
//   // Fetch class by ID
//   Future<ClassModel?> getClassByID(String classID) async {
//     DocumentSnapshot classDoc = await _firestore.collection('classes').doc(classID).get();
//     if (classDoc.exists) {
//       return ClassModel.fromFirestore(classDoc);
//     }
//     return null;
//   }
//
//   // Fetch all classes
//   Future<List<ClassModel>> getAllClasses() async {
//     QuerySnapshot classDocs = await _firestore.collection('classes').get();
//     return classDocs.docs.map((doc) => ClassModel.fromFirestore(doc)).toList();
//   }
//
//   // Fetch all classes for a specific teacher
//   Future<List<ClassModel>> getClassesForTeacher(String teacherID) async {
//     QuerySnapshot classDocs = await _firestore.collection('classes')
//         .where('teacherID', isEqualTo: teacherID)
//         .get();
//     return classDocs.docs.map((doc) => ClassModel.fromFirestore(doc)).toList();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/Views/ClassInfoProvider.dart';
import 'package:untitled1/services/auth/auth_service.dart';
import 'package:untitled1/services/auth/auth_user.dart';
import 'ClassModel.dart';

class ClassService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthUser? user = AuthServices.firebase().currentUser;

  ClassInfoProvider cip = ClassInfoProvider();
  int i = 101;
  Stream<QuerySnapshot> readUploadedClasses() {
    if (user == null) {
      throw Exception("User not authenticated");
    }
    return FirebaseFirestore.instance
        .collection("user-files")
        .doc(user!.id)
        .collection("classes")
        .snapshots();
  }
  Future<void> saveClass(ClassModel classModel) async {
    try {
      if(user == null) {
        throw Exception("User not authenticated");
      } 
      final docRef = _firestore
          .collection("user-files").doc(user?.id).collection("classes")
          .withConverter(
            fromFirestore: ClassModel.fromFirestore,
            toFirestore: (ClassModel classModel, options) =>
                classModel.toFirestore(),
          )
          .doc(classModel.classid);
      await docRef.set(classModel);
      print("✅ Class saved successfully!");
    } catch (e) {
      print("❌ Error saving class: $e");
    }
  }

  Future<void> deleteClass(ClassModel classModel) async {
  try {
    final docRef = _firestore
          .collection("user-files").doc(user?.id).collection("classes")
        .withConverter(
          fromFirestore: ClassModel.fromFirestore,
          toFirestore: (ClassModel classModel, options) =>
              classModel.toFirestore(),
        )
        .doc(classModel.classid);
        
    await docRef.delete();
    print("✅ Class deleted successfully!");
  } catch (e) {
    print("❌ Error deleting class: $e");
  }
}


  Future<Map<String, dynamic>?> getClassByID(String classID) async {
    try {
      final classref = _firestore.collection("classes").doc(classID);
      final docSnap = await classref.get();
      final classModel = docSnap.data();
      if (classModel != null) {
        return classModel; // ✅ Safe casting
      } else {
        print("No class found with given classid");
      }
    } catch (e) {
      print("❌ Error fetching class: $e");
    }
    return null;
  }

  // Future<List<ClassModel>> getAllClasses() async {
  //   try {
  //     // QuerySnapshot classDocs = await _firestore.collection('classes').get();
  //     // return classDocs.docs.map((doc) => ClassModel.fromFirestore(doc.data() ).toList();

  //   } catch (e) {
  //     print("❌ Error fetching all classes: $e");
  //     return [];
  //   }
  // }

//   Future<List<ClassModel>> getClassesForTeacher(String teacherID) async {
//     try {
//       QuerySnapshot classDocs = await _firestore.collection('classes').where('teacherID', isEqualTo: teacherID).get();
//       return classDocs.docs.map((doc) => ClassModel.fromFirestore(doc.data() ).toList();
//     } catch (e) {
//       print("❌ Error fetching classes for teacher: $e");
//       return [];
//     }
//   }
}
