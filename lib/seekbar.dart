import 'package:audio_manager/audio_manager.dart';
import 'package:flutter/material.dart';

import 'PlayBackControls.dart';
import 'SongWidget.dart';
import 'presenter/formatConverter.dart';

class SeekBar extends StatefulWidget {
  final String duration;
  SeekBar({this.duration});
  @override
  _SeekBarState createState() => _SeekBarState();
}

var audioManagerInstance = AudioManager.instance;

class _SeekBarState extends State<SeekBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("formatDuration(audioManagerInstance.position): ${formatDuration(audioManagerInstance.position)}");
    print("formatDuration(audioManagerInstance.duration${parseToMinutesSeconds(int.parse(widget.duration))}))");

    //print("formatDuration(audioManagerInstance.duration${(widget.duration).runtimeType}))");

  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          formatDuration(audioManagerInstance.position),
          //widget.time.inSeconds.toString(),
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
                  max: 10,
                  value: //widget.position.inSeconds.toDouble(),//
                  slider ?? 0,
                  onChanged: (value) {
                    setState(() {
                      slider = value;
                    });
                  },
                  onChangeEnd: (value) {
                    if (audioManagerInstance.duration != null) {
                      Duration msec = Duration(
                          milliseconds:
                          (audioManagerInstance.duration.inMilliseconds * value).round());
                      audioManagerInstance.seekTo(msec);
                    }
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
