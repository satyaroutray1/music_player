import 'dart:async';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(PlayerInitial());

  @override
  Stream<PlayerState> mapEventToState(PlayerEvent event,) async* {

    if (event is Play){
      yield PlayerInitial();
    }

  }
}
