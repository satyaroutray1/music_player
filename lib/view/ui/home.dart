import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import '../../model/DB.dart';
import '../widgets/LoadingIndicator.dart';
import '../widgets/song_list_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
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
                        Hero(
                          tag: 'logo',
                          child: Image.asset('assets/images/headphones.png',
                          height: MediaQuery.of(context).size.width/5,
                            width: MediaQuery.of(context).size.width/5,),
                        ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Music Player', style: TextStyle(
                              fontSize: Theme.of(context).textTheme.headline4.fontSize,
                                color: Colors.white
                            ),textAlign: TextAlign.right,),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.transparent,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 5.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: RaisedButton(onPressed: (){

                                  },
                                    child: Text('Play'),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      //side: BorderSide(color: Colors.red)
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(Icons.favorite_border, color: Colors.grey,)
                              ],
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
                            topRight: Radius.circular(40)
                        ),
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
                                  return SongListWidget(songList: songInfo);
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