import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import 'page_manager.dart';

class SimplePlayer extends StatefulWidget {
  const SimplePlayer({Key? key}) : super(key: key);

  @override
  _SimplePlayerState createState() => _SimplePlayerState();
}

class _SimplePlayerState extends State<SimplePlayer> {
  late final PageManager _pageManager;

  @override
  void initState() {
    super.initState();
    _pageManager = PageManager();
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Spacer(),
            Icon(
              Icons.music_note_rounded,
              size: MediaQuery.of(context).size.width - 120,
              color: Colors.deepPurpleAccent,
            ),
            Spacer(),
            ValueListenableBuilder<ProgressBarState>(
              valueListenable: _pageManager.progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  progress: value.current,
                  buffered: value.buffered,
                  total: value.total,
                  onSeek: _pageManager.seek,
                );
              },
            ),
            ValueListenableBuilder<ButtonState>(
              valueListenable: _pageManager.buttonNotifier,
              builder: (_, value, __) {
                switch (value) {
                  case ButtonState.loading:
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      width: 32.0,
                      height: 32.0,
                      child: CircularProgressIndicator(),
                    );
                  case ButtonState.paused:
                    return IconButton(
                      icon: Icon(Icons.play_arrow),
                      iconSize: 32.0,
                      onPressed: _pageManager.play,
                    );
                  case ButtonState.playing:
                    return IconButton(
                      icon: Icon(Icons.pause),
                      iconSize: 32.0,
                      onPressed: _pageManager.pause,
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
