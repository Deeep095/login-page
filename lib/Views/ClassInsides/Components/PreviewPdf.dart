import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PreviewPdf extends StatefulWidget {
  final String pdfUrl;

  const PreviewPdf({super.key, required this.pdfUrl});
  // const PreviewPDF({Key? key, required this.pdfUrl}) : super(key: key);

  @override
  _PreviewPdfState createState() => _PreviewPdfState();
}

class _PreviewPdfState extends State<PreviewPdf> {
  int? totalPages = 0;
  int currentPage = 0;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Preview23"),
      ),
      body:
          // SfPdfViewer.network(
          //   widget.pdfUrl,
          //   onDocumentLoadFailed: (details) {
          //     ScaffoldMessenger.of(context).showSnackBar(
          //       SnackBar(content: Text("Failed to load PDF: ${details.description}")),
          //     );
          //   },
          // ),
          Stack(
        children: [
          PDFView(
            filePath: widget.pdfUrl,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onRender: (pages) {
              setState(() {
                totalPages = pages;
                isLoading = false;
              });
            },
            onPageChanged: (page, _) {
              setState(() {
                currentPage = page!;
              });
            },
            onError: (error) {
              print("Error loading PDF: $error");
            },
            onPageError: (page, error) {
              print("Error on page $page: $error");
            },
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(
                "Page ${currentPage + 1} of $totalPages",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
