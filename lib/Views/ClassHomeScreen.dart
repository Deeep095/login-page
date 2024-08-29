import 'package:flutter/material.dart';

import '../Constants/routes.dart';
import '../enums/menu_actions.dart';
import '../services/auth/auth_service.dart';

class ClassHomeScreen extends StatefulWidget {

  final String classNumber;
  final String classSection;
  final String classSubject;
  final String classMonitor;


  const ClassHomeScreen({super.key, required this.classNumber, required this.classSection, required this.classSubject, required this.classMonitor});

  @override
  State<ClassHomeScreen> createState() => _ClassHomeScreenState();
}

class _ClassHomeScreenState extends State<ClassHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text(
        'OMG',
        style: TextStyle(color: Colors.white),
      ),
          backgroundColor: Colors.indigoAccent,

    ));
  }
}
