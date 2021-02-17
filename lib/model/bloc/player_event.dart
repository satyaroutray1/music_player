part of 'player_bloc.dart';

@immutable
abstract class PlayerEvent {}

abstract class Play extends PlayerEvent{}

abstract class Pause extends PlayerEvent{}

abstract class Stop extends PlayerEvent{}
