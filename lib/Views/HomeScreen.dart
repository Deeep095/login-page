import 'package:flutter/material.dart';

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

  void _addClass(String classNumber, String classSection, String classSubject,
      String classMonitor) {
    setState(() {
      classes.add('$classNumber - $classSection - $classSubject');
    });
  }

  void _showAddClassDialog() {
    String classNumber = '';
    String classSection = '';
    String classSubject = '';
    String classMonitor = '';

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
                    TextField(
                      onChanged: (value) {
                        // Handle changes to the class number
                        classNumber = value;
                      },
                      decoration:
                          const InputDecoration(hintText: "Enter class number"),
                    ),
                    TextField(
                      onChanged: (value) {
                        classSection = value;
                        // Handle changes to the section number
                      },
                      decoration: const InputDecoration(
                          hintText: "Enter Section number"),
                    ),
                    TextField(
                      onChanged: (value) {
                        classSubject = value;
                        // Handle changes to the subject name
                      },
                      decoration:
                          const InputDecoration(hintText: "Enter Subject name"),
                    ),
                    TextField(
                      onChanged: (value) {
                        classMonitor = value;
                        // Handle changes to the subject name
                      },
                      decoration: const InputDecoration(
                          hintText: "Enter Class Monitor name"),
                    ),
                  ],
                )),
          ),
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
                if (classNumber.isNotEmpty &&
                    classSection.isNotEmpty &&
                    classSubject.isNotEmpty) {
                  print(classNumber);
                  print(classSection);
                  _addClass(
                      classNumber, classSection, classSubject, classMonitor);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              print("Menu button pressed");
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
      body: ListView(
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
          ...classes.map((classInfo) {
            final parts = classInfo.split(' - ');

            // Make sure classInfo has the correct format
            if (parts.length < 3) {
              return const SizedBox.shrink();
            }

            final classNumber = parts[0];
            final classSection = parts[1];
            final classSubject = parts[2];

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
                    onPressed: () {},
                    child: Row(
                      children: [
                        // Image placeholder
                        Container(
                          width: 60, // Adjust size as needed
                          height: 60, // Adjust size as needed
                          margin: const EdgeInsets.only(
                              right: 8.0), // Space between image and text
                          child: Image.asset('classImage.png',
                              fit: BoxFit
                                  .cover), // Replace with your image asset
                        ),

                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$classNumber\n',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Section: $classSection\n',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Subject: $classSubject',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )));
          }),
          if (classes.isEmpty)
            const Center(child: Text('No classes available. Add a new class!')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddClassDialog,
        tooltip: 'Add Class',
        child: const Icon(Icons.add),
      ),
    );
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
