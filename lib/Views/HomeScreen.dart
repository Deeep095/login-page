import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/Classroom.dart';
import 'package:untitled1/Views/ShowAddClassDialog.dart';
import '../Constants/routes.dart';
import '../enums/menu_actions.dart';
import '../services/auth/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> classes = [];
  List<String> classrooms = [];
  // List<Widget> WidgetList = [];

  @override
  Widget build(BuildContext context) {
    ListView(
      padding: const EdgeInsets.all(16.0),
      // children: WidgetList, // Display all the buttons
    );

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
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              // Open drawer or navigate to settings screen
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 100, 100, 100),
                items: [
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Log out'),
                  ),
                ],
              ).then((value) {
                if (value == 'logout') {
                  // Handle logout logic here
                  print("Logged out");
                }
              });
            },
          ),
        ],
      ),
      body:
      ListView(
        children: [
          // Header section
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
          // Classes section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Your Classes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),


          // List of classes

          // ...classes.map((classInfo) => _ClassroomButton(classInfo as Map<String, String>)).toList(),







          ...classes.map((classInfo) {
            final parts = classInfo.split(' - ');

// Make sure classInfo has the correct format
            if (parts.length < 4) {
              return const SizedBox.shrink();
            }

            final classNumber = parts[0];
            final classSection = parts[1];
            final classSubject = parts[2];
            final classMonitor = parts[3];

            return Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11.0),
              child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                    WidgetStateProperty.all<Color>(Colors.blue),
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {
                          return Colors.blue.withOpacity(0.1);
                        }
                        if (states.contains(WidgetState.focused) ||
                            states.contains(WidgetState.pressed)) {
                          return Colors.blue.withOpacity(0.22);
                        }
                        return null; // Defer to the widget's default.
                      },
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            12), // Use circular borders for a softer look
                        side: const BorderSide(color: Colors.black12),
                      ),
                    ),
                    fixedSize: WidgetStateProperty.all<Size>(
                        const Size(200, 100)), // Set the size of the button
                    elevation: WidgetStateProperty.all<double>(
                        8), // Increase elevation for a 3D effect
                    shadowColor: WidgetStateProperty.all<Color>(
                        Colors.black.withOpacity(0.5)), // Shadow color
                    backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.white), // Button background color
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        classHomeScreenRoute, (route) => false);
                  },
                  child: Row(
                    children: [
// Image placeholder
                      Container(
                        width: 60, // Adjust size as needed
                        height: 60, // Adjust size as needed
                        margin: const EdgeInsets.only(right: 15.0),

// Space between image and text
                        child: Image.asset('assets/images/classImage.png',
                            fit: BoxFit.cover),

// Replace with your image asset
                      ),

                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const WidgetSpan(
                                child: SizedBox(
                                    height: 35.0), // Add vertical padding here
                              ),
                              TextSpan(
                                text: '$classNumber\n',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const WidgetSpan(
                                child: SizedBox(
                                    height: 25.0), // Add vertical padding here
                              ),
                              TextSpan(
                                text: 'Section: $classSection\n',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left:
                                      180.0), // Adjust this value to your needs
                                  child: Text(
                                    'Subject: $classSubject',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          }),



















          if (classes.isEmpty)
            const Center(child: Text('No classes available. Add a new class!')),

        ],
      ),


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

    List<String> classes = [];

    String? classNumber;
    String? classSection;
    String? classSubject;
    String? classMonitor;
    int? maxSections = 6;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add New Class'),
            content: Scrollbar(
                child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 200, // Set the maximum height
                maxWidth: 300, // Set the maximum width
                minHeight: 100, // Set the minimum height
                minWidth: 200, // Set the minimum width
              ),
              child: ListWheelScrollView(
                itemExtent: 60,
                magnification: 1,
                children: [
                  DropdownButtonFormField(
                    value: classNumber,
                    onChanged: (value) {
                      setState(() {
                        classNumber = value.toString();
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Select your Class",
                    ),

                    items: [
                      {'id': 1, 'name': '1'},
                      {'id': 2, 'name': '2'},
                      {'id': 3, 'name': '3'},
                      {'id': 4, 'name': '4'},
                      {'id': 5, 'name': '5'},
                      {'id': 6, 'name': '6'},
                      {'id': 7, 'name': '7'},
                      {'id': 8, 'name': '8'},
                      {'id': 9, 'name': '9'},
                      {'id': 10, 'name': '10'},
                      {'id': 11, 'name': '11'},
                      {'id': 12, 'name': '12'},
                    ].map((e) {
                      return DropdownMenuItem(
                        value: e['id'].toString(),
                        child: Text(e['name'].toString()),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    value: classSection,
                    onChanged: (value) {
                      setState(() {
                        classSection = value.toString();
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Select class Section",
                    ),
                    items: getSections(classNumber).map((e) {
                      return DropdownMenuItem(
                        value: e['id'],
                        child: Text(e['name'] ?? ''),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    value: classSubject,
                    onChanged: (value) {
                      setState(() {
                        classSubject = value.toString();
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Select your Subject",
                    ),
                    items: getSubjects(classNumber).map((e) {
                      return DropdownMenuItem(
                        value: e[
                            'id'], // Use the null-aware operator ? to access the 'id' key
                        child: Text(e['name'] ??
                            ''), // Use the null-aware operator ?? to assign an empty string if e['name'] is null
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    value: classMonitor,
                    onChanged: (value) {
                      setState(() {
                        classMonitor = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Select Class Monitor",
                    ),
                    items: [
                      {'id': 'Mr. Smith', 'name': 'Mr. Smith'},
                      {'id': 'Ms. Johnson', 'name': 'Ms. Johnson'},
                      {'id': 'Mr. Davis', 'name': 'Mr. Davis'},
                      {'id': 'Ms. Brown', 'name': 'Ms. Brown'},
                      {'id': 'Mr. Wilson', 'name': 'Mr. Wilson'},
                    ].map((e) {
                      return DropdownMenuItem(
                        value: e['id'],
                        child: Text(e['name'] ?? ''),
                      );
                    }).toList(),
                  ),
                ],
              ),
            )),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  if (classNumber != null &&
                      classSection != null &&
                      classSubject != null) {
                    // if (int.tryParse(classNumber) == null) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //         content: Text('ClassNumber is not Valid')),
                    //   );
                    // } else if (int.tryParse(classSection) == null) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //         content: Text(' Class Section is not Valid ')),
                    //   );
                    // } else if (false) {
                    //   //subjectValidation code required
                    //
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //         content: Text(' Class Subject is not Valid ')),
                    //   );
                    // } else {

                    CreateClass(classNumber, classSection, classSubject, classMonitor);
                    // Navigator.of(context).pop();
                    // //backend
                    // classroom.createClassroom(classNumber, classSection, classSubject, classMonitor);
                    // print(classroom.showButton);

                    // //frontend
                    // showButton();


                  }
                  if (classNumber == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please Enter a Class')),
                    );
                  } else if (classSection == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please Enter a Section')),
                    );
                  } else if (classSubject == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please Enter a Subject')),
                    );
                  }
                },
              ),
            ],
          );
        });
  }



  // Widget _ClassroomButton(Map<String, String> classInfo,) {
  //
  //   String ? classNumber;
  //   String ? classSection;
  //   String ? classSubject;
  //   String ? classMonitor;
  //   return ElevatedButton(
  //     style: ButtonStyle(
  //       foregroundColor: WidgetStateProperty.all<Color>(Colors.blue),
  //       overlayColor: WidgetStateProperty.resolveWith<Color?>(
  //         (Set<WidgetState> states) {
  //           if (states.contains(WidgetState.hovered)) {
  //             return Colors.blue.withOpacity(0.1);
  //           }
  //           if (states.contains(WidgetState.focused) ||
  //               states.contains(WidgetState.pressed)) {
  //             return Colors.blue.withOpacity(0.22);
  //           }
  //           return null; // Defer to the widget's default.
  //         },
  //       ),
  //       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
  //         RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(
  //               12), // Use circular borders for a softer look
  //           side: const BorderSide(color: Colors.black12),
  //         ),
  //       ),
  //       fixedSize: WidgetStateProperty.all<Size>(
  //         const Size(200, 100), // Set the size of the button
  //       ),
  //       elevation: WidgetStateProperty.all<double>(
  //         8, // Increase elevation for a 3D effect
  //       ),
  //       shadowColor: WidgetStateProperty.all<Color>(
  //         Colors.black.withOpacity(0.5), // Shadow color
  //       ),
  //       backgroundColor: WidgetStateProperty.all<Color>(
  //         Colors.white, // Button background color
  //       ),
  //     ),
  //     onPressed: () {
  //       Navigator.of(context)
  //           .pushNamedAndRemoveUntil(classHomeScreenRoute, (route) => false);
  //     },
  //     child: Row(
  //       children: [
  //         // Image placeholder
  //         Container(
  //           width: 60, // Adjust size as needed
  //           height: 60, // Adjust size as needed
  //           margin: const EdgeInsets.only(right: 15.0),
  //           // Space between image and text
  //           child:
  //               Image.asset('assets/images/classImage.png', fit: BoxFit.cover),
  //           // Replace with your image asset
  //         ),
  //         Expanded(
  //           child: RichText(
  //             text: TextSpan(
  //               children: [
  //                 const WidgetSpan(
  //                   child: SizedBox(height: 35.0), // Add vertical padding here
  //                 ),
  //                 TextSpan(
  //                   text: '$classNumber\n',
  //                   style: const TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 const WidgetSpan(
  //                   child: SizedBox(height: 25.0), // Add vertical padding here
  //                 ),
  //                 TextSpan(
  //                   text: 'Section: $classSection\n',
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //                 WidgetSpan(
  //                   child: Padding(
  //                     padding: const EdgeInsets.only(
  //                         left: 180.0), // Adjust this value to your needs
  //                     child: Text(
  //                       'Subject: $classSubject',
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         color: Colors.blue,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //

  int i = 1;
  void CreateClass(String? classNumber,String? classSection,String? classSubject,String? classMonitor) {
    String s = "$classNumber - $classSection - $classSubject - $classMonitor";
    classes.add(s);
    i++;
    Classroom classroom = Classroom();
    Navigator.of(context).pop();
    //backend
    classroom.createClassroom(classNumber, classSection, classSubject, classMonitor);


  }

}


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
