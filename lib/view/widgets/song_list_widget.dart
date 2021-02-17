import 'package:audio_manager/audio_manager.dart';
import 'package:mp/model/DB.dart';
import 'package:mp/view/ui/playmusic.dart';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import '../../presenter/formatConverter.dart';


class SongListWidget extends StatefulWidget {
  final List<SongInfo> songList;

  SongListWidget({@required this.songList});

  @override
  _SongListWidgetState createState() => _SongListWidgetState();
}

class _SongListWidgetState extends State<SongListWidget> with TickerProviderStateMixin {
  var audioManagerInstance;

  @override
  void initState() {
    audioManagerInstance = AudioManager.instance;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
            itemCount: widget.songList.length,
            itemBuilder: (context, songIndex) {
              SongInfo song = widget.songList[songIndex];
              if (song.displayName.contains(".mp3")) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: Theme.of(context).dividerColor, width: 0.7),
                      bottom: BorderSide(
                          color: Theme.of(context).dividerColor, width: 0.7),
                    ),
                  ),
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: ListTile(
                      contentPadding: EdgeInsets.only(top: 5,bottom: 5),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[

                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0.0, 8.0), //(x,y)
                                      blurRadius: 6.0,
                                    ),
                                  ],
                                ),
                                child: song.displayName == sharedPrefs.getCurrentSongName() ?
                                Image.asset('assets/images/pause.png',): Image.asset('assets/images/play.png',),
                            ),
                          )

                        ],
                      ),
                      title: InkWell(
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Hero(
                                    tag: "${(song.title)}",
                                    child: Text(song.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.headline6),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                      parseToMinutesSeconds(int.parse(song.duration)),
                                      style: TextStyle(
                                          fontSize: Theme.of(context).textTheme.subtitle2.fontSize,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),

                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PlayMusic(
                              songpath: "file://${song.filePath}",
                              songName: song.displayName,
                              songInfo: song,
                              songDuration: song.duration.toString(),
                            )),
                          );
                        },
                      ),
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 0,
              );
            }),
      ],
    );
  }
}
