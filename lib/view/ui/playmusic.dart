import 'dart:async';

import 'package:SkyMusicPlayer/view/widgets/seekbar.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import '../../model/DB.dart';
import '../../presenter/formatConverter.dart';
import '../widgets/music_player_button.dart';
import 'home.dart';

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
AudioPlayer audioPlayer;
bool isSongPaused;

class _PlayMusicState extends State<PlayMusic> with SingleTickerProviderStateMixin{

  Animation<double> flipAnimation;
  Animation transformation;
  AnimationController animationController;

  @override
  void initState() {
    audioPlayer = new AudioPlayer();
    position = Duration(milliseconds: 0);
    duration = Duration(seconds: 0);
    initAudioPlayer();

    animationController = AnimationController(duration: Duration(seconds: 5), vsync: this);
    flipAnimation = Tween<double>(begin:  0.0, end: 1).animate(
        CurvedAnimation(parent: animationController,
            curve: Interval(
                0,1, curve: Curves.linear
            ))
    );

    transformation = BorderRadiusTween(
        begin: BorderRadius.circular(125),
        end: BorderRadius.circular(0)).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Curves.easeIn));

    isSongPaused = false;

    super.initState();
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
  void dispose() {
    animationController.dispose();
    super.dispose();
  }



  Future<bool> onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit Music App?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {

              sharedPrefs.setCurrentSongName("");
              audioPlayer.stop();
              Future.delayed(const Duration(milliseconds: 1000), () {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              });
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
          onWillPop: onWillPop,
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
                            onPressed: null,
                            fillColor: Color(0xFFC3F5FF),
                            child: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white,),
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home()),
                                );
                              },
                            ),
                            padding: EdgeInsets.all(0.0),
                            shape: CircleBorder(),
                          ),

                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text('Music Player', style: TextStyle(
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
                              SizedBox(
                                height: 50,
                              ),
                              Hero(
                                tag: "${(widget.songName)}",
                                child: Text(widget.songName,
                                  style: Theme.of(context).textTheme.headline6,
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),

                                child: SeekBar(
                                  duration: widget.songDuration,
                                ),
                              ),

                              SizedBox(
                                height: 50,
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  music_player_button(icon: Icons.replay_30_outlined,
                                    function: () async{
                                      audioPlayer.seek(((position.inMilliseconds - 30000)/1000).toDouble());

                                    },),

                                  music_player_button(icon: isSongPaused? Icons.play_circle_fill: Icons.pause,
                                    function: () async {
                                      if(!isSongPaused) {

                                        await audioPlayer.pause();
                                        animationController.stop();

                                        setState(() {
                                          isSongPaused = true;

                                        });
                                      }else{
                                        setState(() {
                                          isSongPaused =false;

                                        });
                                        audioPlayer.play(widget.songpath, isLocal: true);
                                        audioPlayer.seek(((position.inMilliseconds+1000)/1000).toDouble());
                                        animationController.repeat();
                                      }
                                    },
                                  ),

                                  music_player_button(icon: Icons.play_arrow_rounded,
                                    function: () async{
                                      audioPlayer.stop();

                                      await audioPlayer.play(widget.songpath, isLocal: true);
                                      animationController.repeat();

                                      sharedPrefs.setCurrentSongName("${widget.songName}");
                                    },
                                  ),

                                  music_player_button(icon: Icons.stop,
                                    function: () async{
                                      await audioPlayer.stop();
                                      animationController.reset();
                                    },
                                  ),

                                  music_player_button(icon: Icons.forward_30,
                                    function: ()async{
                                      audioPlayer.seek(((position.inMilliseconds + 30000)/1000).toDouble());
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
                            AnimatedBuilder(
                              animation: animationController,
                              builder: (BuildContext context, Widget child) {
                                return Transform(
                                  transform: Matrix4.identity()
                                    //..setEntry(3, 2, 0.005)
                                    //..rotateY(2*pi* flipAnimation.value)
                                  ,
                                  child: RawMaterialButton(
                                    onPressed: (){

                                    },
                                    elevation: 10.0,
                                    fillColor: Color(0xFFC3F5FF),
                                    child: Hero(
                                      tag: 'logo',
                                      child: RotationTransition(
                                        turns: flipAnimation,
                                        child: Image.asset('assets/images/headphones.png',
                                          height: MediaQuery.of(context).size.width/2.5,
                                          width: MediaQuery.of(context).size.width/2.5,),
                                      ),
                                    ),//Icon(Icons.music_note, size: 180,),
                                    padding: EdgeInsets.all(30.0),
                                    shape: CircleBorder(),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                    ),
                  ],
                ),
              )
          ),
        )
    );
  }
}