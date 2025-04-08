import 'package:flutter/material.dart';
import 'package:untitled1/services/auth/CloudinaryServices.dart';

class PreviewImage extends StatefulWidget {
  final String url;
  final String name ;
  const PreviewImage({super.key, required this.url, this.name = ''});

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Image"),
      ),
      body: Column(
        children: [
          Image.network(
            widget.url,
            fit: BoxFit.fill,
          ),
          Text(
            widget.url,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Logic to download the image
              final donwload_result =
                  await downloadFileFromCloudinary(widget.url, widget.name);
            },
            child: const Text("Download Image"),
          ),
        ],
      ),
    );
  }
}
