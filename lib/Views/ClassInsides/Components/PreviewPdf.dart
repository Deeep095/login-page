// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// // import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class PreviewPdf extends StatefulWidget {
//   final String pdfUrl;

//   const PreviewPdf({super.key, required this.pdfUrl});

//   @override
//   _PreviewPdfState createState() => _PreviewPdfState();
// }

// class _PreviewPdfState extends State<PreviewPdf> {
//   final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("PDF Preview 2344"),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(
//               Icons.bookmark,
//               color: Colors.white,
//               semanticLabel: 'Bookmark',
//             ),
//             onPressed: () {
//               _pdfViewerKey.currentState?.openBookmarkView();
//             },
//           ),
//         ],
//       ),
//       body: SfPdfViewer.network(
//         widget.pdfUrl,
//         key: _pdfViewerKey,
//         onDocumentLoadFailed: (details) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text("Failed to load PDF: ${details.description}")),
//           );
//         },
//       ),
//     );
//   }
// }