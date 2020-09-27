import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPreferences _sharedPrefs;
  Future init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  set shuffle(bool value) => _sharedPrefs.setBool('shuffle', value);
  bool get shuffle => _sharedPrefs.get('shuffle');

  set repeat(String value) => _sharedPrefs.setString('repeat', value);
  String get repeat => _sharedPrefs.get('repeat');
}
