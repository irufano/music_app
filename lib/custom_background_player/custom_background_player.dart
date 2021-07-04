import 'package:flutter/material.dart';
import 'package:music_app/custom_background_player/player_buttons.dart';

import 'seek_bar.dart';

class CustomBackgroundPlayer extends StatefulWidget {
  const CustomBackgroundPlayer({Key? key}) : super(key: key);

  @override
  _CustomBackgroundPlayerState createState() => _CustomBackgroundPlayerState();
}

class _CustomBackgroundPlayerState extends State<CustomBackgroundPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Background Player'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        width: double.infinity,
        child: Column(
          children: [
            Spacer(),
            Image.network(
                'https://www.carplaylife.com/wp-content/uploads/QMUSIC-APP.jpg'),
            Spacer(),
            // title
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(bottom: 10, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text('Speaker'),
                ],
              ),
            ),
            // A seek bar.
            SeekBar(
              duration: Duration.zero,
              position: Duration.zero,
              onChangeEnd: (newPosition) {},
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                skipPreviousButton(context),
                SizedBox(width: 8.0),
                playButton(context),
                SizedBox(width: 8.0),
                skipNextButton(context),
              ],
            ),
            SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }
}
