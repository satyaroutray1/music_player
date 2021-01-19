import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:path_provider/path_provider.dart';

import 'LoadingIndicator.dart';

class MyMusicList extends StatelessWidget {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  Future getNames() async{
    List<ArtistInfo> artists = await audioQuery.getArtists(); // returns all artists available

    artists.forEach( (artist){
      print(artist);
    } );

  }
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: /*FutureBuilder(
        future: FlutterAudioQuery().getSongs(sortType: SongSortType.DISPLAY_NAME),
        builder: (context, snapshot) {
          List<SongInfo> songInfo = snapshot.data;

          if (snapshot.hasData) {
            return Text('');//SongWidget(songList: songInfo);
          }
          return LoadingIndicator();

        },
      ),*/

      FutureBuilder(
        future: getNames(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return Text('audio');
        },

      )
      /*RaisedButton(
          child: Text('a'),
      onPressed: ()async{
        List<ArtistInfo> artists = await audioQuery.getArtists(); // returns all artists available

        artists.forEach( (artist){
          print("artist"); /// prints all artist property values
        } );
      },),

       */
    );
  }
}
