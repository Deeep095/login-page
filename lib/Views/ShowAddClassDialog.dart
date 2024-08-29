import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled1/Classroom.dart';

import '../Classroom.dart';

class showAddClassDialog extends StatefulWidget {
  const showAddClassDialog({super.key});

  @override
  State<showAddClassDialog> createState() => SingleClassroom();
}



class SingleClassroom extends State<showAddClassDialog>{

  List<String> classes = [];


  void addClass(String classNumber, String classSection, String classSubject,
      String classMonitor) {

    setState(() {
      classes.add('$classNumber - $classSection - $classSubject');
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
class ShowAddClassDialog extends State<showAddClassDialog>
{


  static void showAddClassDialog(BuildContext context) {

    String classNumber = '';
    String classSection = '';
    String classSubject = '';
    String classMonitor = '';
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
                  children: [TextField(
                    enabled: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-12cc]')),
                    ],
                    keyboardType: TextInputType.number,
                    keyboardAppearance: Brightness.light,
                    decoration: const InputDecoration(
                      // border: OutlineInputBorder(),
                      hintText: "Enter class number",
                    ),
                    onChanged: (value) {
                      // Handle changes to the class number
                      classNumber = value;
                    },
                  ),
                    TextField(
                      inputFormatters: const [
                        // FilteringTextInputFormatter.allow(RegExp()),
                      ],
                      onChanged: (value) {
                        classSection = value;
                        // Handle changes to the section number
                      },
                      decoration: const InputDecoration(
                          hintText: "Enter Section number"),

                      keyboardType:
                      TextInputType.text, // Customize keyboard type
                      textCapitalization: TextCapitalization.words,
                    ),
                    TextField(
                      onChanged: (value) {
                        classSubject = value;
                        // Handle changes to the subject name
                      },
                      decoration:
                      const InputDecoration(hintText: "Enter Subject name"),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                    TextField(
                      onChanged: (value) {
                        classMonitor = value;
                        // Handle changes to the subject name
                      },
                      decoration: const InputDecoration(
                          hintText: "Enter Class monitor name"),
                      keyboardType:
                      TextInputType.name, // Customize keyboard type
                      textCapitalization: TextCapitalization.words,
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
                  if (int.tryParse(classNumber) == null) {
                    const AlertDialog(
                        semanticLabel:
                        'Please Enter a valid (int) classNumber');
                  } else if (int.tryParse(classSection) == null) {
                    const AlertDialog(
                        semanticLabel:
                        'Please Enter a valid (int) classNumber');
                  }
                  SingleClassroom Classroom = new SingleClassroom();
                  Classroom.addClass(classNumber, classSection, classSubject, classMonitor);
                  Navigator.of(context).pop();
                } else if (classNumber.isEmpty) {
                  const AlertDialog(
                      semanticLabel: 'Please Enter a classNumber');
                } else if (classSection.isEmpty) {
                  const AlertDialog(
                      semanticLabel: 'Please Enter a classSection');
                } else if (classSubject.isEmpty) {
                  const AlertDialog(
                      semanticLabel: 'Please Enter a classSubject');
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
    // TODO: implement build
    throw UnimplementedError();
  }

}






