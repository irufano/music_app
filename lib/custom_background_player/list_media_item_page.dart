import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'audio_player_task.dart';
import 'custom_background_player.dart';
import 'media_library.dart';
import 'playlist_page.dart';

class ListMediaItemPage extends StatefulWidget {
  const ListMediaItemPage({Key? key}) : super(key: key);

  @override
  _ListMediaItemPageState createState() => _ListMediaItemPageState();
}

class _ListMediaItemPageState extends State<ListMediaItemPage> {
  MediaLibrary _mediaLibrary = MediaLibrary();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Podcasts'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => PlaylistPage()));
            },
            icon: Icon(Icons.playlist_play),
          )
        ],
      ),
      body: StreamBuilder<AudioProcessingState>(
          stream: AudioService.playbackStateStream
              .map((state) => state.processingState)
              .distinct(),
          builder: (context, snapshot) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: _mediaLibrary.items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_mediaLibrary.items[index].title),
                      subtitle: Text(_mediaLibrary.items[index].artist!),
                      trailing: IconButton(
                          onPressed: () async {
                            // update dynamic queue:
                            await AudioService.updateMediaItem(
                                _mediaLibrary.items[index]);
                          },
                          icon: Icon(Icons.add)),
                      onTap: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => CustomBackgroundPlayer()));

                        // start service
                        await AudioService.start(
                          backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
                          androidNotificationChannelName: 'Audio Service Demo',
                          // Enable this if you want the Android service to exit the foreground state on pause.
                          //androidStopForegroundOnPause: true,
                          androidNotificationColor: 0xFF2196f3,
                          androidNotificationIcon: 'mipmap/ic_launcher',
                          androidEnableQueue: true,
                          androidStopForegroundOnPause: true,
                          androidNotificationClickStartsActivity: true,
                        );

                        // add dynamic queue:
                        await AudioService.addQueueItem(
                            _mediaLibrary.items[index]);
                      },
                    );
                  }),
            );
          }),
    );
  }
}
