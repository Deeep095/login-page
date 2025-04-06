import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/Backend/ClassModel.dart';
import 'package:untitled1/Backend/ClassService.dart';
import 'package:untitled1/Classroom.dart';
import 'package:untitled1/Views/ClassInsides/ClassDetailScreen.dart';
import 'package:untitled1/Views/ShowAddClassDialog.dart';
import 'package:untitled1/services/auth/DatabaseServices.dart';
import 'package:uuid/uuid.dart';
import '../Constants/routes.dart';
import '../enums/menu_actions.dart';
import '../services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'ClassInfoProvider.dart';
import 'ClassInsides/AddClassDialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/auth/auth_service.dart';
import 'ClassInfoProvider.dart';
import 'ClassInsides/AddClassDialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> classes = [];
  List<String> classrooms = [];
  CollectionReference cr = FirebaseFirestore.instance.collection('users');
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  Future<void> addUser(String userId, String email, String role) async {
    await ref.set({
      "email": email,
      "id": userId,
      "role": role,
    });
  }

  @override
  void initState() {
    super.initState();
    loadClassesFromFirebase();
  }

  void loadClassesFromFirebase() async {
    final firebaseUser = AuthServices.firebase().currentUser;
    final uid = firebaseUser?.id;

    try {
      if (uid != null) {
        final docSnapshot = await ref.get();
        if (!docSnapshot.exists) {
          await addUser(
              firebaseUser!.id, firebaseUser.email, firebaseUser.role);
        }

        // Fetch the teacher's classes from Firebase
        // final snapshot = await teacherRef.get();
        // if (snapshot.exists) {
        //   List<String> fetchedClasses = [];
        //   snapshot.children.forEach((child) {
        //     final classData = child.value as Map;
        //     final classString = "${classData['classNumber']} - ${classData['classSection']} - ${classData['classSubject']} - ${classData['classMonitor']}";
        //     fetchedClasses.add(classString);
        //   });

        //   // Update the class list in the provider
        //   Provider.of<ClassInfoProvider>(context, listen: false).setClasses(fetchedClasses);
        // }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final classInfoProvider = Provider.of<ClassInfoProvider>(context);
    final getClasses = classInfoProvider.classes;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Classroom Clone',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Navigate to notifications screen
            },
          ),

          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);

                  if (shouldLogout) {

                    //await AuthServices.firebase().logOut();not working hanging in screen no o/p
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        onBoardingScreenRoute, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("log out"),
                ),
              ];
            },
          ),

          // IconButton(
          //   icon: const Icon(Icons.menu, color: Colors.white),
          //
          //   onPressed: () {
          //     // Open drawer or navigate to settings screen
          //     showMenu(
          //       context: context,
          //       position: const RelativeRect.fromLTRB(550,70,0,0),
          //       items: [
          //         const PopupMenuItem<String>(
          //           value: 'logout',
          //           child: Text('Log out'),
          //         ),
          //       ],
          //     ).then((value) {
          //       if (value == 'logout') {
          //         // Handle logout logic here
          //         print("Logged out");
          //       }
          //     });
          //   },
          // ),
        ],
      ),
      // key: _scaffoldKey,

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Refresh'),
              onTap: () {
                // Handle the refresh action here
                Navigator.pop(context); // Close the drawer
                // Add your refresh logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove'),
              onTap: () {
                // Handle the remove action here
                Navigator.pop(context); // Close the drawer
                // Add your remove logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                // Handle the edit action here
                Navigator.pop(context); // Close the drawer
                // Add your edit logic
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Handle the settings action here
                Navigator.pop(context); // Close the drawer
                // Add your settings logic
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigoAccent,
            child: const Text(
              'Welcome to Google Classroom Clone',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your Classes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: ClassService().readUploadedClasses(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No classes available. Add a new class!'));
                }

                List<DocumentSnapshot> classDocs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: classDocs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data =
                        classDocs[index].data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 11.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.blue),
                          backgroundColor:
                              WidgetStateProperty.all<Color>(Colors.white),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(color: Colors.black12),
                            ),
                          ),
                          fixedSize: WidgetStateProperty.all<Size>(
                              const Size(200, 100)),
                          elevation: WidgetStateProperty.all<double>(8),
                          shadowColor: WidgetStateProperty.all<Color>(
                              Colors.black.withOpacity(0.5)),
                        ),
                        onPressed: () {
                          // Navigator.of(context).pushNamedAndRemoveUntil(
                          //     '/classHomeScreen/', (route) => false);
                          ClassModel classModel =
                              ClassModel.fromMap(data, classDocs[index].id);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ClassDetailScreen(
                                classModel: classModel,
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              margin: const EdgeInsets.only(right: 15.0),
                              child: Image.asset(
                                  'assets/images/classImage2.jpeg',
                                  fit: BoxFit.cover),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const WidgetSpan(
                                        child: SizedBox(height: 35.0)),
                                    TextSpan(
                                      text: '${data['className']}\n',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    const WidgetSpan(
                                        child: SizedBox(height: 25.0)),
                                    TextSpan(
                                      text: 'Section: ${data['section']}\n',
                                      style: const TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    ),
                                    WidgetSpan(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 180.0),
                                        child: Text(
                                          'Subject: ${data['subject']}',
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.blue),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // More Options Button (Menu)
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'delete') {
                                  // Handle delete action here
                                  ClassModel classModel = ClassModel.fromMap(data, classDocs[index].id);
                                  ClassService().deleteClass(classModel);
                                } 
                                else if (value == 'settings') {
                                  // Navigator.of(context).pushNamed(
                                  //     '/classSettingsScreen/',
                                  //     arguments: data);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.red),
                                      SizedBox(width: 10),
                                      Text('Delete Class'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'settings',
                                  child: Row(
                                    children: [
                                      Icon(Icons.settings, color: Colors.blue),
                                      SizedBox(width: 10),
                                      Text('Class Settings'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // StreamBuilder to listen for changes in Firestore

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          onPressedAddButton();
        },
        tooltip: 'Add Class',
        child: const Icon(Icons.add),
      ),
    );
  }

  void onPressedAddButton() {
    showDialog(
      context: context,
      builder: (context) {
        return AddClassDialog(
          onSaveClass: (classNumber, classSection, classSubject, classMonitor) {
            CreateClass(classNumber, classSection, classSubject, classMonitor);
          },
        );
      },
    );
  }

  void CreateClass(String classNumber, String classSection, String classSubject,
      String classMonitor) async {
    ClassService classService = ClassService();
    final uuid = Uuid();
    String teacherid = "123456";
    try {
      ClassModel classModel = ClassModel(
        classid: uuid.v4(),
        className: classNumber,
        section: classSection,
        subject: classSubject,
        teacherID: teacherid,
        enrolledUser: [],
      );

      await classService.saveClass(classModel);
    } catch (e) {
      print(e);
    }
  }
}

List<Map<String, String>> getSubjects(String? classNumber) {
  if (classNumber == null || int.parse(classNumber) < 5) {
    print("$classNumber  sss");
    return [
      {'id': 'Math', 'name': 'Math'},
      {'id': 'Science', 'name': 'Science'},
      {'id': 'English', 'name': 'English'},
      {'id': 'Hindi', 'name': 'Hindi'},
      {'id': 'Drawing', 'name': 'Drawing'},
    ];
  } else {
    return [
      {'id': 'Math', 'name': 'Math'},
      {'id': 'Science', 'name': 'Science'},
      {'id': 'English', 'name': 'English'},
      {'id': 'History', 'name': 'History'},
      {'id': 'Geography', 'name': 'Geography'},
    ];
  }
}

List<Map<String, String>> getSections(String? classNumber) {
  if (classNumber == null || int.parse(classNumber) < 5) {
    print("$classNumber  sss");
    return [
      {'id': 'A', 'name': 'A'},
      {'id': 'B', 'name': 'B'},
      {'id': 'C', 'name': 'C'},
    ];
  } else {
    return [
      {'id': 'A', 'name': 'A'},
      {'id': 'B', 'name': 'B'},
      {'id': 'C', 'name': 'C'},
      {'id': 'D', 'name': 'D'},
      {'id': 'E', 'name': 'E'},
    ];
  }
}

// void CreateClass(String? classNumber, String? classSection,
//     String? classSubject, String? classMonitor) {
//   setState(() {
//     String s = "$classNumber - $classSection - $classSubject - $classMonitor";
//     classes.add(s);
//     i++;
//     Classroom classroom = Classroom();
//     Navigator.of(context).pop();
//     //backend
//     classroom.createClassroom(
//         classNumber, classSection, classSubject, classMonitor);
//   });
// }

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sign out'),
          content: const Text('Are You Sure you want to SIGN OUT!!'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Log out")),
          ],
        );
      }).then((value) => value ?? false);
}
