import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class LiveStreamPlayer extends StatefulWidget {
  final String streamUrl;
  final String liveStreamId; // Add liveStreamId for API activation

  const LiveStreamPlayer(
      {required this.streamUrl, required this.liveStreamId});

  @override
  _LiveStreamPlayerState createState() => _LiveStreamPlayerState();
}

class _LiveStreamPlayerState extends State<LiveStreamPlayer> {
  late VideoPlayerController _controller;
  bool isLoading = false;
  String statusMessage = "";

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.streamUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  Future<void> startLiveStream() async {
    setState(() {
      isLoading = true;
      statusMessage = "Starting live stream...";
    });

    String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
    String apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? '';
    String apiSecret = dotenv.env['CLOUDINARY_SECRET_KEY'] ?? '';

    final url = Uri.parse(
        'https://api.cloudinary.com/v2/video/$cloudName/live_streams/${widget.liveStreamId}/activate');
    final response = await http.post(
      url,
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}',
      },
    );

    setState(() {
      isLoading = false;
      if (response.statusCode == 200) {
        print("DOne it finally");
        statusMessage = "Live stream started successfully!";
      } else {
        statusMessage =
            "Failed to start live stream: ${response.statusCode} - ${response.body}";
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Live Stream')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : CircularProgressIndicator(),
            ),
          ),
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              statusMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: startLiveStream,
            child: Text('Start Live Stream'),
          ),
        ],
      ),
    );
  }
}
