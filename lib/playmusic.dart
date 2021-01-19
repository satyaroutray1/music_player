import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class PlayMusic extends StatefulWidget {

  final String song;
  PlayMusic({this.song});

  @override
  _PlayMusicState createState() => _PlayMusicState();
}

class _PlayMusicState extends State<PlayMusic> {
  AudioPlayer audioPlayer;
  AudioCache audioCache;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
              child: Column(
                children: [
                  RaisedButton(
                    child: Text('play'),
                    onPressed: () async{
                      //await audioCache.play(widget.song);
                      await audioPlayer.play(widget.song, isLocal: true);
                    },
                  ),

                  RaisedButton(
                    child: Text('stop'),
                    onPressed: () async{
                      await audioPlayer.stop();
                    },
                  ),

                  RaisedButton(
                    child: Text('pause'),
                    onPressed: () async{
                      await audioPlayer.pause();
                    },
                  ),

                  RaisedButton(
                    child: Text('resume'),
                    onPressed: () async{
                      await audioPlayer.resume();
                    },
                  ),

                ],
              ),
            )));
  }
}
