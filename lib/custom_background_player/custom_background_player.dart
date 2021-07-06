import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_app/custom_background_player/playlist_page.dart';

import 'media_state.dart';
import 'player_buttons.dart';
import 'player_stream.dart';
import 'queue_state.dart';
import 'seek_bar.dart';

class CustomBackgroundPlayer extends StatefulWidget {
  const CustomBackgroundPlayer({Key? key}) : super(key: key);

  @override
  _CustomBackgroundPlayerState createState() => _CustomBackgroundPlayerState();
}

class _CustomBackgroundPlayerState extends State<CustomBackgroundPlayer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Background Player'),
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
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        width: double.infinity,
        child: StreamBuilder<bool>(
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
              return Center(child: Text("Audio service is not running"));
            } else {
              return StreamBuilder<AudioProcessingState>(
                  stream: AudioService.playbackStateStream
                      .map((state) => state.processingState)
                      .distinct(),
                  builder: (context, snapshot) {
                    final processingState =
                        snapshot.data ?? AudioProcessingState.none;

                    if (processingState == AudioProcessingState.none) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else
                      return Column(
                        children: [
                          Spacer(),
                          StreamBuilder<QueueState>(
                            stream: playerStream.queueStateStream,
                            builder: (context, snapshot) {
                              final queueState = snapshot.data;
                              final mediaItem = queueState?.mediaItem;

                              var imageUrl = mediaItem?.artUri != null
                                  ? mediaItem!.artUri
                                  : null;

                              if (imageUrl == null)
                                return Container(
                                  color: Theme.of(context).primaryColor,
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.width - 32,
                                  child: Center(
                                      child: Icon(
                                    Icons.mic_outlined,
                                    color: Colors.white,
                                    size: MediaQuery.of(context).size.width / 3,
                                  )),
                                );
                              else
                                return Image.network(
                                  imageUrl.origin + imageUrl.path,
                                  height: MediaQuery.of(context).size.width,
                                );
                            },
                          ),
                          Spacer(),

                          // controller
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.height < 800
                                      ? MediaQuery.of(context).size.width / 2.5
                                      : 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // title
                                  StreamBuilder<QueueState>(
                                      stream: playerStream.queueStateStream,
                                      builder: (context, snapshot) {
                                        final queueState = snapshot.data;
                                        final mediaItem = queueState?.mediaItem;

                                        var title = mediaItem?.title != null
                                            ? mediaItem!.title
                                            : '-';

                                        var artist = mediaItem?.artist != null
                                            ? mediaItem!.artist
                                            : '-';

                                        return Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              bottom: 16, top: 8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Text(
                                                  title,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              Text(artist.toString()),
                                            ],
                                          ),
                                        );
                                      }),

                                  // A seek bar.
                                  StreamBuilder<MediaState>(
                                      stream: playerStream.mediaStateStream,
                                      builder: (context, snapshot) {
                                        final mediaState = snapshot.data;
                                        return SeekBar(
                                          duration:
                                              mediaState?.mediaItem?.duration ??
                                                  Duration.zero,
                                          position: mediaState?.position ??
                                              Duration.zero,
                                          onChangeEnd: (newPosition) {
                                            AudioService.seekTo(newPosition);
                                          },
                                        );
                                      }),
                                  SizedBox(height: 16.0),

                                  // controller button
                                  StreamBuilder<QueueState>(
                                      stream: playerStream.queueStateStream,
                                      builder: (context, snapshot) {
                                        final queueState = snapshot.data;
                                        final queue = queueState?.queue ?? [];
                                        final mediaItem = queueState?.mediaItem;

                                        print(
                                            '--- queue length : ${queue.length} ---');

                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            if (queue.isNotEmpty)
                                              Row(
                                                children: [
                                                  // prev
                                                  skipPreviousButton(
                                                    context,
                                                    onPressed:
                                                        mediaItem == queue.first
                                                            ? null
                                                            : AudioService
                                                                .skipToPrevious,
                                                  ),
                                                  SizedBox(width: 8.0),

                                                  // Play/pause/stop buttons.
                                                  StreamBuilder<bool>(
                                                      stream: AudioService
                                                          .playbackStateStream
                                                          .map((state) =>
                                                              state.playing)
                                                          .distinct(),
                                                      builder:
                                                          (context, snapshot) {
                                                        final playing =
                                                            snapshot.data ??
                                                                false;

                                                        if (playing)
                                                          return pauseButton(
                                                              context);
                                                        else
                                                          return playButton(
                                                              context);
                                                      }),
                                                  SizedBox(width: 8.0),

                                                  // next
                                                  skipNextButton(context,
                                                      onPressed: mediaItem ==
                                                              queue.last
                                                          ? null
                                                          : AudioService
                                                              .skipToNext),
                                                ],
                                              ),
                                          ],
                                        );
                                      }),
                                  SizedBox(height: 8.0),

                                  // Display the processing state.
                                  StreamBuilder<AudioProcessingState>(
                                    stream: AudioService.playbackStateStream
                                        .map((state) => state.processingState)
                                        .distinct(),
                                    builder: (context, snapshot) {
                                      final processingState = snapshot.data ??
                                          AudioProcessingState.none;
                                      return Text(
                                          "Processing state: ${describeEnum(processingState)}");
                                    },
                                  ),
                                  // // Display the latest custom event.
                                  // StreamBuilder(
                                  //   stream: AudioService.customEventStream,
                                  //   builder: (context, snapshot) {
                                  //     return Text(
                                  //         "custom event: ${snapshot.data}");
                                  //   },
                                  // ),
                                  // // Display the notification click status.
                                  // StreamBuilder<bool>(
                                  //   stream: AudioService
                                  //       .notificationClickEventStream,
                                  //   builder: (context, snapshot) {
                                  //     return Text(
                                  //       'Notification Click Status: ${snapshot.data}',
                                  //     );
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                  });
            }
          },
        ),
      ),
    );
  }
}
