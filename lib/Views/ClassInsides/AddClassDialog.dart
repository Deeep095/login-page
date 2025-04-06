import 'package:flutter/material.dart';

class AddClassDialog extends StatefulWidget {
  final Function(String, String, String, String) onSaveClass;

  const AddClassDialog({required this.onSaveClass, super.key});

  @override
  _AddClassDialogState createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  String? classNumber;
  String? classSection;
  String? classSubject;
  String? classMonitor;

  bool canSaveClass = false;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Add New Class'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          DropdownButtonFormField(
            value: classNumber,
            onChanged: (value) {
              setState(() {
                classNumber = value.toString();
                classSection = null;
              });
            },
            decoration: const InputDecoration(labelText: "Select your Class"),
            items: [
              '1','2','3','4','5','6','7','8','9','10','11','12'
            ].map((e) {
              return DropdownMenuItem(value: e, child: Text(e));
            }).toList(),
          ),
          DropdownButtonFormField(
            value: classSection,
            onChanged: (value) {
              setState(() {
                classSection = value.toString();
              });
            },
            decoration:
                const InputDecoration(labelText: "Select class Section"),
            items: ['A', 'B', 'C', 'D', 'E'].map((e) {
              return DropdownMenuItem(value: e, child: Text(e));
            }).toList(),
          ),
          DropdownButtonFormField(
            value: classSubject,
            onChanged: (value) {
              setState(() {
                classSubject = value.toString();
              });
            },
            decoration: const InputDecoration(labelText: "Select Subject"),
            items:
                ['Math', 'Science', 'English', 'History', 'Geography'].map((e) {
              return DropdownMenuItem(value: e, child: Text(e));
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
        ]
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
            if (classNumber != null &&
                classSection != null &&
                classSubject != null) {
              widget.onSaveClass(
                classNumber!, // Use non-nullable operator because we checked it
                classSection!,
                classSubject!,
                classMonitor ?? '', // Class monitor is optional, default to an empty string
              );
              Navigator.of(context).pop();
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
  }


}

