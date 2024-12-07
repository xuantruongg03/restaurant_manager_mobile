import 'package:shared_preferences/shared_preferences.dart';
import 'encryption_service.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  // Singleton pattern
  static StorageService? _instance;
  static Future<StorageService> getInstance() async {
    _instance ??= StorageService(await SharedPreferences.getInstance());
    return _instance!;
  }

  // Lưu dữ liệu với key tùy chọn
  Future<bool> setString(String key, String value) async {
    final encrypted = EncryptionService.encrypt(value);
    return await _prefs.setString(key, encrypted);
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  // Lưu object dạng JSON
  Future<bool> setObject(String key, Map<String, dynamic> value) async {
    final encrypted = EncryptionService.encryptObject(value);
    return await _prefs.setString(key, encrypted);
  }

  // Lưu list object dạng JSON
  Future<bool> setObjectList(String key, List<Map<String, dynamic>> value) async {
    final encrypted = EncryptionService.encryptList(value);
    return await _prefs.setString(key, encrypted);
  }

  // Lấy dữ liệu
  String? getString(String key) {
    final encrypted = _prefs.getString(key);
    if (encrypted == null) return null;
    return EncryptionService.decrypt(encrypted);
  }

  int? getInt(String key) => _prefs.getInt(key);
  double? getDouble(String key) => _prefs.getDouble(key);
  bool? getBool(String key) => _prefs.getBool(key);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // Lấy object dạng JSON
  Map<String, dynamic>? getObject(String key) {
    final encrypted = _prefs.getString(key);
    if (encrypted == null) return null;
    return EncryptionService.decryptObject(encrypted);
  }

  // Lấy list object dạng JSON
  List<Map<String, dynamic>>? getObjectList(String key) {
    final encrypted = _prefs.getString(key);
    if (encrypted == null) return null;
    return EncryptionService.decryptList(encrypted);
  }

  // Kiểm tra key tồn tại
  bool hasKey(String key) => _prefs.containsKey(key);

  // Xóa dữ liệu theo key
  Future<bool> remove(String key) async => await _prefs.remove(key);

  // Xóa tất cả dữ liệu
  Future<bool> clear() async => await _prefs.clear();

  // Lấy tất cả keys
  Set<String> getKeys() => _prefs.getKeys();
}