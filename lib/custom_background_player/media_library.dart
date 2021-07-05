import 'package:audio_service/audio_service.dart';

class MediaLibrary {
  final _items = <MediaItem>[
    MediaItem(
      // This can be any unique id, but we use the audio URL for convenience.
      id: "1",
      album: "Science Friday",
      title: "A Salute To Head-Scratching Science",
      artist: "Science Friday and WNYC Studios",
      duration: Duration(milliseconds: 5739820),
      artUri: Uri.parse(
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
      extras: {
        "source":
            "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"
      },
    ),
    MediaItem(
      id: "2",
      album: "Science Friday",
      title: "From Cat Rheology To Operatic Incompetence",
      artist: "Science Friday and WNYC Studios",
      duration: Duration(milliseconds: 2856950),
      artUri: Uri.parse(
          "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg"),
      extras: {
        "source": "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3"
      },
    ),
  ];

  List<MediaItem> get items => _items;
}
