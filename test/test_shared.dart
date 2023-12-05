// shared_preferences_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<int> getCounter() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt('counter') ?? 0;
  }

  Future<int> incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;
    await prefs.setInt('counter', counter);
    return counter;
  }
}
