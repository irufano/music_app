import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'audio_player_task.dart';
import 'custom_background_player.dart';
import 'media_library.dart';
import 'player_stream.dart';
import 'playlist_page.dart';
import 'queue_state.dart';

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
          // final processingState = snapshot.data ?? AudioProcessingState.none;

          return Stack(
            children: [
              Container(
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
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     fullscreenDialog: true,
                          //     builder: (context) => CustomBackgroundPlayer()));

                          // start service
                          await AudioService.start(
                            backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
                            androidNotificationChannelName:
                                'Audio Service Demo',
                            // Enable this if you want the Android service to exit the foreground state on pause.
                            //androidStopForegroundOnPause: true,
                            androidNotificationColor: 0xFF2196f3,
                            androidNotificationIcon: 'mipmap/ic_launcher',
                            androidEnableQueue: false,
                            androidStopForegroundOnPause: true,
                            androidNotificationClickStartsActivity: true,
                          );

                          // if (processingState == AudioProcessingState.ready)
                          //   // update dynamic queue:
                          //   await AudioService.updateMediaItem(
                          //       _mediaLibrary.items[index]);
                          // else
                          // add dynamic queue:
                          await AudioService.addQueueItem(
                              _mediaLibrary.items[index]);

                          // await AudioService.playMediaItem(
                          //     _mediaLibrary.items[index]);
                        },
                      );
                    }),
              ),

              // player indicator
              StreamBuilder<bool>(
                stream: AudioService.runningStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.active) {
                    // Don't show anything until we've ascertained whether or not the
                    // service is running, since we want to show a different UI in
                    // each case.
                    return SizedBox();
                  }

                  final audioServiceRunning = snapshot.data ?? false;
                  if (!audioServiceRunning) {
                    return SizedBox();
                  } else {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: StreamBuilder<QueueState>(
                        stream: playerStream.queueStateStream,
                        builder: (context, snapshot) {
                          final queueState = snapshot.data;
                          final mediaItem = queueState?.mediaItem;

                          var title =
                              mediaItem?.title != null ? mediaItem!.title : '-';

                          var artist = mediaItem?.artist != null
                              ? mediaItem!.artist
                              : '-';

                          var imageUrl = mediaItem?.artUri != null
                              ? mediaItem!.artUri
                              : null;

                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) =>
                                      CustomBackgroundPlayer()));
                            },
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 20,
                                    offset: Offset(4, 8), // Shadow position
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  (imageUrl == null)
                                      ? Container(
                                          width: 64,
                                          color: Theme.of(context).primaryColor,
                                          child: Center(
                                            child: Icon(
                                              Icons.mic_outlined,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        )
                                      : Image.network(
                                          imageUrl.origin + imageUrl.path,
                                        ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 16.0, right: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                              child: Text(title,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14))),
                                          Flexible(
                                              child: Padding(
                                            padding: EdgeInsets.only(top: 6.0),
                                            child: Text(artist!),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 0,
                                    child: StreamBuilder<bool>(
                                        stream: AudioService.playbackStateStream
                                            .map((state) => state.playing)
                                            .distinct(),
                                        builder: (context, snapshot) {
                                          final playing =
                                              snapshot.data ?? false;

                                          if (playing)
                                            return IconButton(
                                              icon: Icon(Icons.pause),
                                              onPressed: AudioService.pause,
                                            );
                                          else
                                            return IconButton(
                                              icon: Icon(Icons.play_arrow),
                                              onPressed: AudioService.play,
                                            );
                                        }),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }
}
