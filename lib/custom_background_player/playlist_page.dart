import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'player_stream.dart';
import 'queue_state.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist'),
      ),
      body: StreamBuilder<QueueState>(
        stream: playerStream.queueStateStream,
        builder: (context, snapshot) {
          final queueState = snapshot.data;
          final playlist = queueState?.queue ?? [];
          final mediaItem = queueState?.mediaItem;

          return Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: playlist.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(playlist[index].title),
                  subtitle: Text(playlist[index].artist!),
                  trailing: StreamBuilder<bool>(
                    stream: AudioService.playbackStateStream
                        .map((state) => state.playing)
                        .distinct(),
                    builder: (context, snapshot) {
                      final playing = snapshot.data ?? false;

                      return IconButton(
                          onPressed: () {
                            if ((mediaItem == playlist[index]) && (playing)) {
                              AudioService.pause();
                            } else {
                              if (mediaItem == playlist[index])
                                AudioService.play();
                              else
                                AudioService.skipToQueueItem(
                                    playlist[index].id);

                              if (!playing) {
                                AudioService.play();
                              }
                            }
                          },
                          icon: Icon((mediaItem == playlist[index]) && (playing)
                              ? Icons.pause
                              : Icons.play_arrow));
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
