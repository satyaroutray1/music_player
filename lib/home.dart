import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
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
  AudioCache audioCache;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: audioPlayer);

    getL();
  }

  Future<String> getL() async {
    final directory = await getApplicationDocumentsDirectory();

    print(directory.path);
    return directory.path;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
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
              )
              /*Column(
                children: [
                  RaisedButton(
                    child: Text('play'),
                    onPressed: () async{
                      await audioCache.play('audio/new.mp3');
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
                      await audioPlayer.resume();// .play('audio/new.mp3');
                    },
                  ),

                  MyMusicList()
                ],
              ),*/
            )
        )
    );
  }
}