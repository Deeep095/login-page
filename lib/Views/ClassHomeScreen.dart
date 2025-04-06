import 'package:flutter/material.dart';


class ClassHomeScreen extends StatefulWidget {
  final String classNumber;
  final String classSection;
  final String classSubject;
  final String classMonitor;

  const ClassHomeScreen(
      {super.key,
      required this.classNumber,
      required this.classSection,
      required this.classSubject,
      required this.classMonitor});

  @override
  State<ClassHomeScreen> createState() => _ClassHomeScreenState();
}

class _ClassHomeScreenState extends State<ClassHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/homeScreen/', (route) => false);// Go back to the previous screen
          },
        ),
        title: const Text(
          'OMG',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Class Home Screen!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Add more widgets here to build out the page content
            Text(
              'This is where you can manage your classes.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
