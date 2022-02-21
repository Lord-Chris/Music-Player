// ignore_for_file: constant_identifier_names

import 'package:hive_flutter/adapters.dart';
part 'app_player_state.g.dart';

@HiveType(typeId: 6)
enum AppPlayerState {
  @HiveField(0)
  Idle,
  @HiveField(1)
  Playing,
  @HiveField(2)
  Paused,
  @HiveField(3)
  Finished,
}
