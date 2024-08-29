import 'dart:math';

import 'package:untitled1/services/auth/auth_service.dart';

class Classroom {
  late final String id;
  late final String className;
  late final String ownerId;
  late final DateTime createdAt;
  late bool showButton = false;
  Classroom();

  // Create a set to store unique IDs
  Set<int> uniqueIds = <int>{};

// Function to generate a new, unique ID
  int getNewUniqueId() {
    int newId;
    do {
      newId = Random().nextInt(1000000); // generate a random integer between 0 and 999999
    } while (uniqueIds.contains(newId)); // check if the ID is already in the set
    uniqueIds.add(newId); // add the new ID to the set
    return newId;
  }

  // factory Classroom.fromFirestore(Map<String, dynamic> data) {
  //   return Classroom(
  //     id: data['id'],
  //     className: data['className'],
  //     ownerId: data['ownerId'],
  //     createdAt: (data['createdAt'] ).toDate(),
  //
  //   );
  // }

  void createClassroom(String? classNumber,String? classSection,String? classSubject,String? classMonitor)
  {
    this.id = getNewUniqueId().toString();
    this.className = "Class - $classNumber";
    this.createdAt = DateTime.now();
    this.ownerId = AuthServices.firebase().currentUser.toString();
    this.showButton = true;

  }
}
