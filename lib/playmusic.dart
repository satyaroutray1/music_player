import 'dart:async';
import 'dart:ffi';

import 'package:audio_manager/audio_manager.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:mp/seekbar.dart';
import 'SongWidget.dart';
import 'presenter/formatConverter.dart';

class PlayMusic extends StatefulWidget {

  final String songpath, songName;
  final String songDuration;
  final SongInfo songInfo;
  PlayMusic({this.songpath, this.songName, this.songDuration, this.songInfo});

  @override
  _PlayMusicState createState() => _PlayMusicState();
}

enum PlayerState { stopped, playing, paused }

Duration duration;
Duration position;
class _PlayMusicState extends State<PlayMusic> with SingleTickerProviderStateMixin{

  AudioPlayer audioPlayer;
  //AudioCache audioCache;
  var audioManagerInstance;

  Animation flipAnimation;
  AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = new AudioPlayer();
    //audioCache = new AudioCache(fixedPlayer: audioPlayer);
    audioManagerInstance = AudioManager.instance;
    position = Duration(milliseconds: 0);
    duration = Duration(seconds: 0);
    initAudioPlayer();

    animationController = AnimationController(duration: Duration(seconds: 1), vsync: this);
    flipAnimation = Tween(begin:  0.0, end: 1).animate(
        CurvedAnimation(parent: animationController,
            curve: Interval(
                0,1, curve: Curves.linear
            ))
    );
  }

  void now(){
    print(position.runtimeType);
  }


  PlayerState playerState = PlayerState.stopped;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';
  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }
  void initAudioPlayer() {
    _positionSubscription = audioPlayer.onAudioPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });

    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
          if (s == AudioPlayerState.PLAYING) {
            setState(() {
              duration = audioPlayer.duration;
            });
          } else if (s == AudioPlayerState.STOPPED) {
            onComplete();
            setState(() {
              position = duration;
            });
          }
        }, onError: (msg) {
          setState(() {
            playerState = PlayerState.stopped;
            duration = Duration(seconds: 0);
            position = parseDuration(widget.songDuration);
            //Duration(seconds: 0);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RawMaterialButton(
                          onPressed: (){

                          },
                          //elevation: 2.0,
                          fillColor: Color(0xFFC3F5FF),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          padding: EdgeInsets.all(0.0),
                          shape: CircleBorder(),
                        ),

                        Padding(padding: EdgeInsets.only(top: 10),
                        child: Text('Now Playing', style: TextStyle(
                          color: Colors.white,
                          fontSize: Theme.of(context).textTheme.headline5.fontSize //.headline3.height
                        ),))
                      ],
                    ),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Hero(
                          tag: "${(widget.songName)}",
                          child: Text(widget.songName,
                              style: Theme.of(context).textTheme.headline6
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),

                          child: SeekBar(

                            duration: widget.songDuration,
                          ),
                        ),

                        SizedBox(
                          height: 20,
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MusicSystem(icon: Icons.play_arrow_rounded,
                              function: () async{
                                audioPlayer.stop();

                                await audioPlayer.play(widget.songpath, isLocal: true);

                                audioManagerInstance
                                    .start("${widget.songpath}",
                                    widget.songInfo.title,
                                    desc: widget.songInfo.displayName,
                                    auto: true,
                                    cover: widget.songInfo.albumArtwork)
                                    .then((err) {
                                  print(err);
                                });

                              },),
                            MusicSystem(icon: Icons.pause,
                            function: () async{
                              await audioPlayer.pause();
                              initAudioPlayer();

                            },),
                            MusicSystem(icon: Icons.stop,
                            function: () async{
                              await audioPlayer.stop();
                              audioManagerInstance.stop();
                            },),

                            MusicSystem(icon: Icons.forward_30,
                            function: ()async{
                              audioPlayer.seek(((position.inMilliseconds + 30000)/1000).toDouble());
                            },),

                            MusicSystem(icon: Icons.replay_30_outlined,
                            function: () async{
                              audioPlayer.seek(((position.inMilliseconds - 30000)/1000).toDouble());

                            },),

                          ],
                        ),

                      ],
                    )
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .21,
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RawMaterialButton(
                            onPressed: (){

                            },
                              elevation: 10.0,
                              fillColor: Color(0xFFC3F5FF),
                              child: Hero(
                                tag: 'logo',
                                child: Image.asset('assets/images/headphones.png',
                                  height: MediaQuery.of(context).size.width/2.5,
                                  width: MediaQuery.of(context).size.width/2.5,),
                              ),//Icon(Icons.music_note, size: 180,),
                            padding: EdgeInsets.all(30.0),
                            shape: CircleBorder(),
                          ),

                        ],
                      )
                  ),
                ],
              ),
            )
        )
    );
  }
}

class MusicSystem extends StatefulWidget {

  IconData icon;
  Function function;
  
  MusicSystem({this.icon, this.function});

  @override
  _MusicSystemState createState() => _MusicSystemState();
}

class _MusicSystemState extends State<MusicSystem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        flex: 1,
        child: RawMaterialButton(
          onPressed: (){
            widget.function();
          },
          //elevation: 2.0,
          fillColor: Color(0xFF70C4D5),
          child: Icon(widget.icon, color: Colors.white,
          ),
          shape: CircleBorder(),
        ),
      ),
    );
  }
}
