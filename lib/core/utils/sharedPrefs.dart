import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences? _sharedPrefs;
  static SharedPrefs? _prefs;

  static Future<SharedPrefs?> getInstance() async {
    if (_prefs == null) {
      SharedPrefs placeholder = SharedPrefs();
      await placeholder.init();
      _prefs = placeholder;
    }
    return _prefs;
  }

  Future<void> removedata(String key) async {
    await _sharedPrefs!.remove(key);
  }

  Future init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  Future<void> saveString(String key, String value) async {
    await _sharedPrefs!.setString(key, value);
  }

  Future<void> saveInt(String key, int value) async {
    await _sharedPrefs!.setInt(key, value);
  }

  Future<void> saveDouble(String key, double value) async {
    await _sharedPrefs!.setDouble(key, value);
  }

  Future<void> saveBool(String key, bool value) async {
    await _sharedPrefs!.setBool(key, value);
  }

  Future<void> saveStringList(String key, List<String> value) async {
    await _sharedPrefs!.setStringList(key, value);
  }

  String readString(String key, {String? def}) {
    return _sharedPrefs!.getString(key) ?? def!;
  }

  int readInt(String key, {int? def}) {
    return _sharedPrefs!.getInt(key) ?? def!;
  }

  double readDouble(String key, {double? def}) {
    return _sharedPrefs!.getDouble(key) ?? def!;
  }

  bool readBool(String key, {bool? def}) {
    return _sharedPrefs!.getBool(key) ?? def!;
  }

  List<String> readStringList(String key, {List<String>? def}) {
    return _sharedPrefs!.getStringList(key) ?? def!;
  }
}