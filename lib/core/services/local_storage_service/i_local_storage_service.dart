import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ILocalStorageService {
  Future<void> init();
  Future<Box<T>> openBox<T>({required String boxId});
  Future<void> writeToBox<T>(String key, T data, {String? boxId});
  T getFromBox<T>(String key, {String? boxId, T? def});
  Future<void> clearBox({String? boxId});
}
