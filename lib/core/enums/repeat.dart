// ignore_for_file: constant_identifier_names

import 'package:hive_flutter/adapters.dart';
part 'repeat.g.dart';

@HiveType(typeId: 7)
enum Repeat {
  @HiveField(0)
  All,
  @HiveField(1)
  One,
  @HiveField(2)
  Off
}
