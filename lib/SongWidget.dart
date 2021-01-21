import 'package:audio_manager/audio_manager.dart';
import 'package:mp/playmusic.dart';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'seekbar.dart';
import 'presenter/formatConverter.dart';


class SongWidget extends StatefulWidget {
  final List<SongInfo> songList;

  SongWidget({@required this.songList});

  @override
  _SongWidgetState createState() => _SongWidgetState();
}
var audioManagerInstance = AudioManager.instance;

class _SongWidgetState extends State<SongWidget> with TickerProviderStateMixin {
  @override
  void initState() {
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
              if (song.displayName.contains(".mp3"))
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
                      contentPadding: EdgeInsets.zero,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 20.0,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              showMenu(
                                  context: context,
                                  position: RelativeRect.fromLTRB(100, 100, 0,
                                      100), //TODO Should not be constant
                                  items: [
                                    PopupMenuItem<String>(
                                        child: const Text('Like'),
                                        value: 'Doge'),
                                    PopupMenuItem<String>(
                                        child: const Text('Add to Playlist'),
                                        value: 'Lion'),
                                    PopupMenuItem<String>(
                                        child: const Text('Song info'),
                                        value: 'Lion'),
                                  ]);
                            },
                          )
                        ],
                      ),
                      title: InkWell(
                        onTap: () {
                          print("file://${song.filePath}");
                          print(song.duration.runtimeType);
                          print(song.duration);
                          print(parseToMinutesSeconds(int.parse(song.duration)));

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PlayMusic(
                              songpath: "file://${song.filePath}",
                              songName: song.displayName,
                              songInfo: song,
                              songDuration: song.duration.toString(),


                            )),
                          );

                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.6,
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(song.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .headline6),
                                  Text(song.artist,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2),
                                  Text(
                                      parseToMinutesSeconds(
                                          int.parse(song.duration)),
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              return SizedBox(
                height: 0,
              );
            }),
        //PlayBackControls()
      ],
    );
  }
}
