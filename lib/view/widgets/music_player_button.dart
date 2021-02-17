
import 'package:flutter/material.dart';

class music_player_button extends StatefulWidget {

  IconData icon;
  Function function;

  music_player_button({this.icon, this.function,});

  @override
  _music_player_buttonState createState() => _music_player_buttonState();
}

class _music_player_buttonState extends State<music_player_button> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        flex: 1,
        child: RawMaterialButton(
          onPressed: (){
            //widget.function();
          },
          //elevation: 2.0,
          fillColor: Color(0xFF70C4D5),
          child: IconButton(
            icon: Icon(widget.icon,
              color: Colors.white,
            ),
            onPressed: (){
              widget.function();
            },
          ),
          shape: CircleBorder(),
        ),
      ),
    );
  }
}
