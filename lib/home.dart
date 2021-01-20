
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:path_provider/path_provider.dart';

import 'LoadingIndicator.dart';
import 'SongWidget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  AudioPlayer audioPlayer;
  //AudioCache audioCache;

  @override
  void initState() {
    super.initState();
    audioPlayer = new AudioPlayer();
    //audioCache = new AudioCache(fixedPlayer: audioPlayer);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
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

                    height: MediaQuery.of(context).size.height*.25,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.music_note_outlined, size: 30,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Music Player', style: TextStyle(
                              fontSize: 25,
                            ),textAlign: TextAlign.center,),
                            RaisedButton(onPressed: (){

                              },
                              child: Text('Play'),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: new EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .25,),
                    
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40)),

                      ),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: FutureBuilder(
                              future: FlutterAudioQuery().getSongs(sortType: SongSortType.DISPLAY_NAME),
                              builder: (context, snapshot) {
                                List<SongInfo> songInfo = snapshot.data;
                                if (snapshot.hasData) {
                                  return SongWidget(songList: songInfo);
                                }
                                return LoadingIndicator();
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            )
        )
    );
  }
}