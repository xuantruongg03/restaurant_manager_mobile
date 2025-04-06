import 'dart:convert';

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

  //Set object
  Future<bool> setObject(String key, Object value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  //Get object
  Object? getObject(String key) {
    final String? value = _prefs.getString(key);
    return value != null ? jsonDecode(value) : null;
  }

  //Set list
  Future<bool> setList(String key, List<dynamic> value) async {
    return await _prefs.setString(key, jsonEncode(value));
  }

  //Get list
  List<Object>? getList(String key) {
    final String? value = _prefs.getString(key);
    if (value != null) {
        final decoded = jsonDecode(value);
        if (decoded is List) {
            return List<Object>.from(decoded);
        } else {
            // Xử lý trường hợp không phải là danh sách
            print('Dữ liệu không phải là danh sách: $decoded');
            return null;
        }
    }
    return null; 
  }
}
