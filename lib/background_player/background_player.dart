import 'package:flutter/material.dart';

class BackgroundPlayer extends StatefulWidget {
  const BackgroundPlayer({Key? key}) : super(key: key);

  @override
  _BackgroundPlayerState createState() => _BackgroundPlayerState();
}

class _BackgroundPlayerState extends State<BackgroundPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Background Player'),
      ),
    );
  }
}
