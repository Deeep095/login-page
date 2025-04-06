import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled1/services/auth/CloudinaryServices.dart';
import 'package:untitled1/services/auth/auth_service.dart';
import 'package:untitled1/services/auth/auth_user.dart';

class DbService {
  AuthUser? user = AuthServices.firebase().currentUser;

  void UpdateDescription(
      String description, String classID,String publicID) async {
    if (user == null) {
      throw Exception("User not authenticated");
    }
    print("Description: $description");
    await FirebaseFirestore.instance
        .collection("user-files")
        .doc(AuthServices.firebase().currentUser!.id)
        .collection("classes")
        .doc(classID)
        .collection("uploads")
        .doc(publicID)
        .update({
      "description": description,
    });
  }

  // save files links to firestore
  Future<void> saveUploadedFilesData(
      Map<String, String> data, String modelclassID) async {
    if (user == null) {
      throw Exception("User not authenticated");
    }
    return FirebaseFirestore.instance
        .collection("user-files")
        .doc(user!.id)
        .collection("classes")
        .doc(modelclassID)
        .collection("uploads")
        .doc(data["id"])
        .set(data);
  }

  // read all uploaded files
  Stream<QuerySnapshot> readUploadedFiles(String classID) {
    // print(classID);
    if (user == null) {
      throw Exception("User not authenticated");
    }
    return FirebaseFirestore.instance
        .collection("user-files")
        .doc(user!.id)
        .collection("classes")
        .doc(classID)
        .collection("uploads")
        .snapshots();
  }

  // delete a specific document
  void deleteFile(String classModelID, String publicId) async {
    // print(classModelID);

    if (user == null) {
      throw Exception("User not authenticated");
    }
    await FirebaseFirestore.instance
        .collection("user-files")
        .doc(user!.id)
        .collection("classes")
        .doc(classModelID)
        .collection("uploads")
        .doc(publicId)
        .delete();
  }

  // cannot delete the file from DB for no reason the same code is directly working fine
}
