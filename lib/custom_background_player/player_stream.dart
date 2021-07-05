import 'package:audio_service/audio_service.dart';
import 'package:music_app/custom_background_player/media_state.dart';
import 'package:music_app/custom_background_player/queue_state.dart';
import 'package:rxdart/rxdart.dart';

class PlayerStream {
  /// A stream reporting the combined state of the current queue and the current
  /// media item within that queue.
  Stream<QueueState> get queueStateStream =>
      Rx.combineLatest2<List<MediaItem>?, MediaItem?, QueueState>(
          AudioService.queueStream,
          AudioService.currentMediaItemStream,
          (queue, mediaItem) => QueueState(queue, mediaItem));

  /// A stream reporting the combined state of the current media item and its
  /// current position.
  Stream<MediaState> get mediaStateStream =>
      Rx.combineLatest2<MediaItem?, Duration, MediaState>(
          AudioService.currentMediaItemStream,
          AudioService.positionStream,
          (mediaItem, position) => MediaState(mediaItem, position));
}

final PlayerStream playerStream = PlayerStream();
