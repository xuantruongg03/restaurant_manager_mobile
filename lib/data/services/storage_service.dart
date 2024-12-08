import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Singleton pattern
  static StorageService? _instance;
  static Future<StorageService> getInstance() async {
    _instance ??= StorageService(await SharedPreferences.getInstance());
    return _instance!;
  }

  // String operations
  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // Boolean operations
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  // Check if key exists
  bool hasKey(String key) {
    return _prefs.containsKey(key);
  }

  // Clear storage
  Future<bool> clear() async {
    return await _prefs.clear();
  }

  // Remove specific key
  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }
}