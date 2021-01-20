import 'dart:ffi';

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
              height: double.infinity,
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      const Color(0xFFC3F5FF),
                      const Color(0xFF70C4D5),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*.3,

                    child: Text('Now Playing'),
                  ),

                  Container(
                    padding: new EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .3,),
                    child: Container(
                      //color: Colors.white,
                    height: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(250),
                          ),

                      ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .27,

                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.music_note, size: 80,)
                        ],
                      )
                  ),
                ],
              ),
            )));
  }
}
