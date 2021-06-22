import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import 'page_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final PageManager _pageManager;

  @override
  void initState() {
    super.initState();
    _pageManager = PageManager();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Spacer(),
              ProgressBar(
                progress: Duration.zero,
                total: Duration.zero,
              ),
              IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 32.0,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
