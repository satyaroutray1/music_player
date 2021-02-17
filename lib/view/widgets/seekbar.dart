import 'package:flutter/material.dart';

import 'package:mp/view/ui/playmusic.dart';
import '../../presenter/formatConverter.dart';


class SeekBar extends StatefulWidget {
  final String duration;
  final Duration currentPosition;
  SeekBar({this.duration, this.currentPosition});

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("formatDuration(audioManagerInstance.duration${parseToMinutesSeconds(int.parse(widget.duration))}))");

    print("${(parseToMinutesSeconds(duration.inMilliseconds))}");

    print("${(duration).runtimeType}");
  }


  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          //formatDuration(audioManagerInstance.position),
          parseToMinutesSeconds(position.inMilliseconds),
          style: Theme.of(context).textTheme.subtitle2,
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbColor: Theme.of(context).accentColor,
                  overlayColor: Theme.of(context).dividerColor,
                  thumbShape: RoundSliderThumbShape(
                    disabledThumbRadius: 3,
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 10,
                  ),
                  activeTrackColor: Theme.of(context).accentColor,
                  inactiveTrackColor: Theme.of(context).dividerColor,
                ),
                child: Slider(
                  min: 0.0,
                  max: (int.parse(widget.duration)).toDouble(),
                  value: (position.inMilliseconds).toDouble(),
                  onChanged: (value) {

                  },
                  onChangeEnd: (value) {
                  },
                )),
          ),
        ),

        Text(
          //formatDuration(audioManagerInstance.duration),
          parseToMinutesSeconds(int.parse(widget.duration)),
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ],
    );
  }
}
void seekToSecond(int second){
  Duration newDuration = Duration(seconds: second);
  //audioPlayer.seek(newDuration);
}
