// // import 'package:flutter/material.dart';
// //
// // class Testing extends StatefulWidget {
// //   const Testing({super.key});
// //
// //   @override
// //   State<Testing> createState() => _TestingState();
// // }
// //
// // class _TestingState extends State<Testing> {
// //   String? dropDownValue; // Initialize with null
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: DropdownButton<String>(
// //           value: dropDownValue, // Use the current value
// //           icon: const Icon(Icons.menu),
// //           hint: const Text('Select a class'), // Add a hint for the initial state
// //           onChanged: (String? newValue) {
// //             setState(() {
// //               dropDownValue = newValue; // Update the value
// //             });
// //           },
// //           items: List.generate(12, (index) {
// //             return DropdownMenuItem<String>(
// //               value: (index + 1).toString(),
// //               child: Text('Class ${(index + 1).toString()}'),
// //             );
// //           }),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
// // //
// ...classes.map((classInfo) {
// final parts = classInfo.split(' - ');
//
// // Make sure classInfo has the correct format
// if (parts.length < 3) {
// return const SizedBox.shrink();
// }
//
// final classNumber = parts[0];
// final classSection = parts[1];
// final classSubject = parts[2];
//
// return Padding(
// padding:
// const EdgeInsets.symmetric(vertical: 8.0, horizontal: 11.0),
// child: ElevatedButton(
// style: ButtonStyle(
// foregroundColor:
// WidgetStateProperty.all<Color>(Colors.blue),
// overlayColor: WidgetStateProperty.resolveWith<Color?>(
// (Set<WidgetState> states) {
// if (states.contains(WidgetState.hovered)) {
// return Colors.blue.withOpacity(0.1);
// }
// if (states.contains(WidgetState.focused) ||
// states.contains(WidgetState.pressed)) {
// return Colors.blue.withOpacity(0.22);
// }
// return null; // Defer to the widget's default.
// },
// ),
// shape: WidgetStateProperty.all<RoundedRectangleBorder>(
// RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(
// 12), // Use circular borders for a softer look
// side: const BorderSide(color: Colors.black12),
// ),
// ),
// fixedSize: WidgetStateProperty.all<Size>(
// const Size(200, 100)), // Set the size of the button
// elevation: WidgetStateProperty.all<double>(
// 8), // Increase elevation for a 3D effect
// shadowColor: WidgetStateProperty.all<Color>(
// Colors.black.withOpacity(0.5)), // Shadow color
// backgroundColor: WidgetStateProperty.all<Color>(
// Colors.white), // Button background color
// ),
// onPressed: () {
// Navigator.of(context).pushNamedAndRemoveUntil(
// classHomeScreenRoute, (route) => false);
// },
// child: Row(
// children: [
// // Image placeholder
// Container(
// width: 60, // Adjust size as needed
// height: 60, // Adjust size as needed
// margin: const EdgeInsets.only(right: 15.0),
//
// // Space between image and text
// child: Image.asset('assets/images/classImage.png',
// fit: BoxFit.cover),
//
// // Replace with your image asset
// ),
//
// Expanded(
// child: RichText(
// text: TextSpan(
// children: [
// const WidgetSpan(
// child: SizedBox(
// height: 35.0), // Add vertical padding here
// ),
// TextSpan(
// text: '$classNumber\n',
// style: const TextStyle(
// fontSize: 20,
// fontWeight: FontWeight.bold,
// color: Colors.black,
// ),
// ),
// const WidgetSpan(
// child: SizedBox(
// height: 25.0), // Add vertical padding here
// ),
// TextSpan(
// text: 'Section: $classSection\n',
// style: const TextStyle(
// fontSize: 18,
// color: Colors.grey,
// ),
// ),
// WidgetSpan(
// child: Padding(
// padding: const EdgeInsets.only(
// left:
// 180.0), // Adjust this value to your needs
// child: Text(
// 'Subject: $classSubject',
// style: const TextStyle(
// fontSize: 16,
// color: Colors.blue,
// ),
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// ],
// )),
// );
// }),
// // // if (classes.isEmpty)
// // // const Center(child: Text('No classes available. Add a new class!')),