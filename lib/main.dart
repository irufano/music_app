import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_app/custom_background_player/custom_background_player.dart';

import 'background_player/background_player.dart';
import 'simple_player/simple_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        primarySwatch: Colors.deepPurple,
      ),
      home: AudioServiceWidget(child: MyHome()),
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Simple Player'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SimplePlayer()));
                  },
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Background Player'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BackgroundPlayer()));
                  },
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Custom Background Player'),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => CustomBackgroundPlayer()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
