import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

Widget playButton(BuildContext context) => Material(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: AudioService.play,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_arrow,
            size: 48,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget pauseButton(BuildContext context) => Material(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: AudioService.pause,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.pause,
            size: 48,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget stopButton(BuildContext context) => Material(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        onTap: AudioService.stop,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.stop,
            size: 48,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget skipPreviousButton(BuildContext context, {Function()? onPressed}) =>
    IconButton(
      icon: Icon(Icons.skip_previous_rounded),
      iconSize: 48.0,
      onPressed: onPressed,
    );

Widget skipNextButton(BuildContext context, {Function()? onPressed}) =>
    IconButton(
      icon: Icon(Icons.skip_next_rounded),
      iconSize: 48.0,
      onPressed: onPressed,
    );
