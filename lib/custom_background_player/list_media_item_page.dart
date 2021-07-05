import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'audio_player_task.dart';
import 'custom_background_player.dart';
import 'media_library.dart';

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
      ),
      body: StreamBuilder<AudioProcessingState>(
          stream: AudioService.playbackStateStream
              .map((state) => state.processingState)
              .distinct(),
          builder: (context, snapshot) {
            final processingState = snapshot.data ?? AudioProcessingState.none;

            return Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: _mediaLibrary.items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_mediaLibrary.items[index].title),
                      subtitle: Text(_mediaLibrary.items[index].artist!),
                      trailing: Text(
                          RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                                  .firstMatch(
                                      "${_mediaLibrary.items[index].duration}")
                                  ?.group(1) ??
                              '${_mediaLibrary.items[index].duration}'),
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

                        if (processingState == AudioProcessingState.ready) {
                          // update dynamic queue:
                          await AudioService.updateMediaItem(
                              _mediaLibrary.items[index]);
                        } else {
                          // add dynamic queue:
                          await AudioService.addQueueItem(
                              _mediaLibrary.items[index]);
                        }
                      },
                    );
                  }),
            );
          }),
    );
  }
}