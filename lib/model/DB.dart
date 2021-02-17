import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

  static SharedPreferences _sharedPrefs;
  init() async {
    if (_sharedPrefs == null) {
      _sharedPrefs = await SharedPreferences.getInstance();
    }
  }

  static final String _kCurrentSongName = "no_song";

  getCurrentSongName() {
    return _sharedPrefs.getString(_kCurrentSongName) ?? 'en';
  }

 setCurrentSongName(String value) async {
    return _sharedPrefs.setString(_kCurrentSongName, value);
  }
}

final sharedPrefs = SharedPrefs();