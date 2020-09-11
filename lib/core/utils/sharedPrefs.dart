import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences _sharedPrefs;
  Future init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  saveString(String key, String value) async {
    await init();
    _sharedPrefs.setString(key, value);
  }

  saveBool(String key, bool value) async {
    await init();
    _sharedPrefs.setBool(key, value);
  }

  saveInt(String key, int value) async {
    await init();
    _sharedPrefs.setInt(key, value);
  }

  saveDouble(String key, double value) async {
    await init();
    _sharedPrefs.setDouble(key, value);
  }

  saveList(String key, List<String> value) async {
    await init();
    _sharedPrefs.setStringList(key, value);
  }
}
