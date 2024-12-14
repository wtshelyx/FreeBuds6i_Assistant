// TODO: Refactor this pice of shit ;_;
// I need to write like 10 lines for every new settings, and it's probably not
// working correctly. Use rxdart or smth
import 'package:async/async.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

abstract class AppSettings {
  Stream<bool> get seenIntroduction;

  Future<bool> setSeenIntroduction(bool value);
}

enum _Prefs {
  seenIntroduction('seenIntroduction', false);

  const _Prefs(this.key, this.defaultValue);

  final String key;
  final dynamic defaultValue;
}

// TODO: Improve everything here with rxdart or something
class SharedPreferencesAppSettings implements AppSettings {
  SharedPreferencesAppSettings(this.preferences);

  final Future<StreamingSharedPreferences> preferences;

  Future<Preference<bool>> get _seenIntroduction =>
      preferences.then((p) => p.getBool(_Prefs.seenIntroduction.key,
          defaultValue: _Prefs.seenIntroduction.defaultValue));

  @override
  Stream<bool> get seenIntroduction => LazyStream(() => _seenIntroduction);

  @override
  Future<bool> setSeenIntroduction(bool value) =>
      _seenIntroduction.then((v) => v.setValue(value));
}
