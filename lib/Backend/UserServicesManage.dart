import 'package:cloud_firestore/cloud_firestore.dart';

import 'UserModel.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create or update a user in Firestore
  Future<void> saveUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set(user.toFirestore());
  }

  // Fetch user by ID
  Future<UserModel?> getUserByID(String userID) async {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userID).get();
    if (userDoc.exists) {
      return UserModel.fromFirestore(userDoc);
    }
    return null;
  }

  // Fetch all users by role
  Future<List<UserModel>> getUsersByRole(String role) async {
    QuerySnapshot userDocs = await _firestore.collection('users')
        .where('role', isEqualTo: role)
        .get();
    return userDocs.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }

  // Fetch all students in a specific class
  Future<List<UserModel>> getStudentsInClass(String classID) async {
    QuerySnapshot studentDocs = await _firestore.collection('users')
        .where('role', isEqualTo: 'student')
        .where('classIDs', arrayContains: classID)
        .get();
    return studentDocs.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
  }
}
